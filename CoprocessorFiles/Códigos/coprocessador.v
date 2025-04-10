module coprocessador(
    input clk, reset,                // Clock e sinal de reset
    input [15:0] Mem_data,           // Dados lidos da memória (16 bits)
    input Start_process,             // Sinal para iniciar o processamento
    output reg LED,                  // LED de status
    output [15:0] result_wire,       // Resultado para escrita na memória
    output [7:0] mem_address,        // Endereço de memória atual
    output WB_wire,                  // Sinal de Write Back (controle memória)
    output DONE,                     // Sinal de operação concluída
    output overflow,                 // Flag de overflow da ULA
    output [5:0] first_element       // Primeiro elemento da matriz (para debug)
);
    
    // Definição dos estados da máquina de estados
    parameter FETCH = 3'b000;       // Estado de busca de instrução
    parameter DECODE = 3'b001;      // Estado de decodificação
    parameter EXECUTE = 3'b010;     // Estado de execução
    parameter WRITEBACK = 3'b011;   // Estado de escrita dos resultados
    parameter CLEANUP = 3'b100;     // Estado de limpeza/preparação

    // Registros para controle da máquina de estados
    reg [2:0] state_reg, state_next;  // Estado atual e próximo estado

    // ======= REGISTRADORES DE CONTROLE =======
    reg [2:0] opcode;               // Código da operação atual
    reg [2:0] matrix_size;          // Tamanho da matriz (ex: 3 = 3x3)
    reg [199:0] matrix1, matrix2;   // Matrizes de entrada (200 bits cada)
    reg [7:0] real_number;          // Valor escalar para operações
    reg [7:0] address;              // Endereço de memória atual
    reg [6:0] instructionReg;       // Registrador de instrução
    reg [199:0] result;             // Resultado das operações
    reg WB;                         // Controle de escrita na memória
    reg loadingMatrix;              // Flag de carregamento de matriz
    reg [4:0] load_counter;         // Contador para carregamento
    reg [7:0] base_address;         // Endereço base para carregamento
    reg [15:0] write_data;          // Dados para escrita na memória
    reg [4:0] store_counter;        // Contador para armazenamento
    reg [2:0] write_counter;        // Contador de ciclos de escrita
    reg [5:0] det_counter;          // Contador para cálculo de determinante
    reg write_done;                 // Flag de escrita concluída
    reg load_done;                  // Flag de carregamento concluído
    reg [2:0] row1, row2;           // Índices de linha para matrizes
    reg [2:0] col1, col2;           // Índices de coluna para matrizes
    reg [4:0] virt_idx1, virt_idx2; // Índices virtuais para matrizes planas
    reg read_pending;               // Flag de leitura pendente
    reg fetch_done;                 // Flag de busca concluída
    reg fetch_pending;              // Flag de busca pendente
    reg det_done;                   // Flag de determinante concluído

    // ======= CONEXÕES DE FIO =======
    wire [199:0] ula_result;       // Resultado da ULA
    wire [2:0] size_wire;          // Tamanho da matriz (para ULA)
    
    // Atribuições contínuas para saídas
    assign WB_wire = WB;                          // Sinal de Write Back
    assign mem_address = address;                 // Endereço de memória
    assign result_wire = write_data;              // Dados para escrita
    assign first_element = matrix1[16:8];         // Debug: primeiro elemento
    assign size_wire = matrix_size;               // Tamanho para ULA
    assign DONE = (state_reg == CLEANUP);         // Sinal de operação concluída

    // Instância da Unidade Lógica Aritmética (ULA)
    alu ALU(
        .A_flat(matrix1),         // Matriz de entrada A (formatada)
        .B_flat(matrix2),         // Matriz de entrada B (formatada)
        .scalar(real_number),     // Valor escalar para operações
        .opcode(opcode),          // Código da operação
        .clock(clk),              // Clock
        .C_flat(ula_result),      // Resultado da operação
        .overflow_flag(overflow), // Flag de overflow
        .matrix_size(size_wire)   // Tamanho da matriz
    );

    // Lógica de transição de estados (clock ou reset)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= FETCH;  // Reset coloca no estado inicial
        end else begin
            state_reg <= state_next;  // Transição normal de estados
        end
    end
    
    // Lógica combinacional para determinar próximo estado
    always @(*) begin
        case (state_reg)
            FETCH: begin
                // Vai para DECODE quando Start_process for ativado
                state_next = (Start_process) ? DECODE : FETCH;
            end
            
            DECODE: begin
                // Após decodificar, vai para EXECUTE
                state_next = EXECUTE;
            end
            
            EXECUTE: begin
                // Lógica complexa para determinar próximo estado
                if (opcode == 3'b000 && load_done == 1) begin
                    state_next = CLEANUP;  // Carregamento concluído
                end else if (opcode == 3'b000 && load_done == 0) begin
                    state_next = EXECUTE;  // Continua carregando
                end else if (opcode == 3'b111 && det_done == 0) begin
                    state_next = EXECUTE;  // Continua cálculo do determinante
                end else begin
                    state_next = WRITEBACK; // Operação concluída, vai para escrita
                end
            end
            
            WRITEBACK: begin
                // Vai para CLEANUP quando escrita concluída
                state_next = (write_done) ? CLEANUP : WRITEBACK;
            end
            
            CLEANUP: begin
                // Volta para FETCH para nova operação
                state_next = FETCH;
            end
            
            default: begin
                state_next = FETCH;  // Estado padrão
            end
        endcase
    end

    // Lógica principal do pipeline (executada a cada clock)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset de todos os registradores e flags
            instructionReg <= 7'b0;  
            opcode <= 3'b0;           
            matrix_size <= 3'b0;
            Flag_A <= 1'b0;                   
            WB <= 1'b0;               
            result <= 200'b0; 
            loadingMatrix <= 0;
            load_counter <= 0;
            base_address <= 0;
            write_done <= 1'b0;
            load_done <= 0;
            store_counter <= 0;
            write_counter <= 0;
            address <= 0;
            fetch_done <=0;
            fetch_pending <=0;
            det_done <= 0;
        end else begin
            case (state_reg)
                // Estado FETCH: busca a instrução
                FETCH: begin
                    address <= 8'b0;           // Zera endereço
                    LED <= 1'b1;              // Acende LED
                    fetch_pending <= 1;       // Marca busca pendente
                    instructionReg <= Mem_data[6:0];  // Lê instrução
                end
                
                // Estado DECODE: interpreta a instrução
                DECODE: begin
                    opcode <= instructionReg[0 +: 3];  // Bits 0-2: opcode
                    matrix_size <= instructionReg[3 +: 3]; // Bits 3-5: tamanho
                    address <= 8'b00000001;   // Próximo endereço
                    Flag_A <= instructionReg[6 +: 1]; // Bit 6: flag A/B
                    LED <= 1'b0;              // Apaga LED
                end

                // Estado EXECUTE: executa a operação
                EXECUTE: begin
                    case (opcode)
                        // Operação 000: LOAD MATRIX
                        3'b000: begin
                            if (!loadingMatrix) begin
                                // Inicia processo de carregamento
                                loadingMatrix <= 1;
                                load_counter <= 0;
                                base_address <= address;
                                read_pending <= 1;
                                // Zera a matriz destino
                                if (Flag_A == 0) matrix1 <= 200'b0;
                                else matrix2 <= 200'b0;
                            end else if (read_pending) begin
                                // Espera 1 ciclo para Mem_data estar disponível
                                read_pending <= 0;
                            end else begin
                                read_pending <= 1;
                                // Carrega 2 elementos por ciclo (otimização)
                                if (load_counter < (matrix_size * matrix_size)) begin
                                    // Calcula posição do primeiro elemento
                                    row1 = load_counter / matrix_size;
                                    col1 = load_counter % matrix_size;
                                    virt_idx1 = row1 * 5 + col1;
                                    
                                    // Armazena na matriz apropriada
                                    if (Flag_A == 0) begin
                                        matrix1[virt_idx1*8 +: 8] <= Mem_data[15:8];
                                    end else begin
                                        matrix2[virt_idx1*8 +: 8] <= Mem_data[15:8];
                                    end
                                end
                                
                                // Segundo elemento do par
                                if ((load_counter + 1) < (matrix_size * matrix_size)) begin
                                    row2 = (load_counter + 1) / matrix_size;
                                    col2 = (load_counter + 1) % matrix_size;
                                    virt_idx2 = row2 * 5 + col2;
                                    
                                    if (Flag_A == 0) begin
                                        matrix1[virt_idx2*8 +: 8] <= Mem_data[7:0];
                                    end else begin
                                        matrix2[virt_idx2*8 +: 8] <= Mem_data[7:0];
                                    end
                                end
                                
                                // Atualiza contadores e endereço
                                load_counter <= load_counter + 2;
                                if ((load_counter + 2) >= (matrix_size * matrix_size)) begin
                                    load_done <= 1;  // Carregamento concluído
                                end else begin
                                    address <= address + 1;  // Próximo endereço
                                end
                            end
                        end
                        
                        // Operações 001-110: operações matriciais
                        3'b001, 3'b010, 3'b011, 3'b100, 3'b110: begin
                            result <= ula_result;  // Armazena resultado da ULA
                            address <= 8'b00000011; // Endereço para escrita
                            LED <= 1'b1;           // LED indica processamento
                        end

                        // Operação 101: multiplicação por escalar
                        3'b101: begin
                            result <= ula_result;  // Resultado da ULA
                            real_number <= matrix2[0 +: 8]; // Pega escalar
                            address <= 8'b00000011;
                            LED <= 1'b1;
                        end
                        
                        // Operação 111: cálculo de determinante
                        3'b111: begin
                            det_done <= 0;
                            result <= ula_result;
                            address <= 8'b00000011; 
                            LED <= 1'b1;
                            if(det_counter < 3) begin
                                det_counter = det_counter + 1;
                            end else begin
                                det_done <= 1;  // Determinante concluído
                            end
                        end
                    endcase
                end
                
                // Estado WRITEBACK: escreve resultados na memória
                WRITEBACK: begin
                    LED <= 1'b1;        // LED indica escrita
                    WB <= 1'b1;         // Ativa sinal de escrita

                    // Escreve 2 elementos por ciclo (otimização)
                    write_data[15:8] <= result[store_counter*8 +: 8];  // Elemento 1
                    write_data[7:0] <= result[(store_counter+1)*8 +: 8]; // Elemento 2

                    // Calcula endereço de escrita
                    address <= 8'd14 + (store_counter >> 1);

                    // Controle de ciclos de escrita
                    if (write_counter < 3) begin
                        write_counter <= write_counter + 1;
                    end else begin
                        write_counter <= 0;
                        store_counter <= store_counter + 2;

                        // Verifica se todos elementos foram escritos
                        if (store_counter >= 24) begin  // 25 elementos (5x5)
                            WB <= 0;            // Desativa escrita
                            store_counter <= 0; // Zera contador
                            write_done <= 1'b1; // Marca escrita concluída
                        end
                    end
                end
        
                // Estado CLEANUP: prepara para próxima operação
                CLEANUP: begin
                    // Reseta todos os registradores e flags
                    instructionReg <= 15'b0;
                    opcode <= 3'b000;
                    matrix_size <= 3'b000;
                    Flag_A <= 1'b0;
                    WB <= 1'b0;
                    result <= 200'b0;
                    LED <= 1'b0;
                    address <= 8'b0;
                    loadingMatrix <= 0;
                    load_counter <= 0;
                    base_address <= 0;
                    write_done <= 1'b0;
                    load_done <= 0;
                    store_counter <= 0;
                    write_counter <= 0;
                    write_data <= 16'b0;
                    fetch_done <=0;
                    read_pending <=0;
                    fetch_pending <=0;
                    det_done <= 0;
                end
            endcase
        end
    end
    
    // Bloco de debug para monitorar estados
    always @(posedge clk) begin
        $display("State Reg: %b, State Next: %b", state_reg, state_next);
    end

endmodule
