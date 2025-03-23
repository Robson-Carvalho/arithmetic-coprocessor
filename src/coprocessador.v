module coprocessador(
    input clk, reset,
    input [14:0] instruction,
    input erro,
    output reg done
);

    // Estados do processador
    parameter FETCH = 2'b00;
    parameter DECODE = 2'b01;
    parameter EXECUTE = 2'b10;

    reg [1:0] state_reg, state_next;

    // Campos da instrução
    reg [2:0] opcode;   // Código de operação
    reg [2:0] matrix_size;
    reg [199:0] matrix1, matrix2;
    reg [8:0] real_number;
    reg WB;
    reg [7:0] address;
    reg [14:0] instructionReg;

    // Fios de saída dos módulos
    wire [199:0] ula_result;
    wire [255:0] Matrix_z;
    reg [199:0] result;

    // Flags
    reg Flag_A;

    // Unidade Lógica Aritmética (ULA)
    malu ALU(
        .A_flat(matrix1),
        .B_flat(matrix2),
        .n(matrix_size),
        .f(real_number),
        .opcode(opcode),
        .C_flat(ula_result)
    );

    // Módulo de memória
    mem_Interface mem(
        .address(address),
        .clk(clk),
        .data_In(result),
        .wren(WB),
        .q(Matrix_z)
    );

    // Lógica de transição de estados
    always @(posedge clk or posedge reset) begin
        if (reset)
            state_reg <= FETCH;
        else
            state_reg <= state_next; // Estado avança corretamente
    end

    // Lógica combinacional para o próximo estado
    always @(*) begin
        case (state_reg)
            FETCH: state_next = DECODE;
            DECODE: state_next = EXECUTE;
            EXECUTE: state_next = FETCH;
            default: state_next = FETCH;
        endcase
    end

    // Lógica do pipeline
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instructionReg <= 15'b0;  
            opcode <= 3'b0;           
            matrix_size <= 3'b0;      
            address <= 8'b0;          
            Flag_A <= 1'b0;           
            matrix1 <= 200'b0;        
            matrix2 <= 200'b0;        
            WB <= 1'b0;               
            result <= 200'b0;         
            done <= 0;                // Inicializando done como 0
        end else begin
            case (state_reg)
                FETCH: begin
                    instructionReg = instruction;
                    WB = 1'b0;
                end
                
                DECODE: begin
                    opcode = instructionReg[0 +: 3];
                    matrix_size = instructionReg[3 +: 3];
                    address = instructionReg[6 +: 8];
                    Flag_A = instructionReg[14 +: 1];
                end

                EXECUTE: begin
                    case (opcode)
                        3'b000: begin                   // Load
                            if(Flag_A == 0) begin
                                matrix1 = Matrix_z;
                            end else begin
                                matrix2 = Matrix_z;
                            end
                        end
                        3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111: begin  // Operações
                            result = ula_result;
                            WB = 1'b1;
									 done = 1'b1;
                        end
                        default: begin
                            done = 1'b1;   // Finaliza o processo
                        end
                    endcase
                end
            endcase
        end
    end

endmodule
