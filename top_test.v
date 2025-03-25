module top_test();
    // Matrizes de entrada do módulo ALU
    reg [199:0] A_flat;
    reg [199:0] B_flat;

    // Matriz de saída do módulo ALU - Saídas de módulos sempre devem ser wire.
    wire [199:0] C_flat;

    // Tamanho da matriz quadrada NxN - Não está sendo utilizada no módulo ALU
    reg [2:0] n;
    // Decimal de entrada do módulo ALU
    reg [7:0] f;
    // Código de operação para o módulo ALU
    reg [2:0] opcode;

    // Flags de overflow e finalização da operação
    wire overflow_flag; 
    wire done;

    // Instância do módulo ALU
    alu module_alu (
        .A_flat(A_flat),
        .B_flat(B_flat),
        .f(f),
        .opcode(opcode),
        .C_flat(C_flat),
        .overflow_flag(overflow_flag),
        .done(done)
    );


    // Função de teste para exibição das matrizes de forma legível. Apenas para fim de verificação dos resultados.
    task display_matrix;
      input [199:0] matrix;
      input [2:0] size;
      integer r, c;
      begin
        for (r = 0; r < size; r = r + 1) begin
          $write("[");
          for (c = 0; c < size; c = c + 1) begin
            $write("%d", $signed(matrix[(r*5 + c)*8 +: 8]));
            if (c < size - 1) $write(" ");
          end
          $display("]");
        end
      end
    endtask


    // Início dos testes
    initial begin
      // Valores da matrizes de entrada para testes das operações.
      // Cada dois dígitos dessa sequência hexadecimal representa 1 Byte.
      A_flat = 200'h000000000000000000000000000000000000000000000E0E0E; 
      B_flat = 200'h00000000000000000000000000000000000000000000030201; 

      // Valor para visualização das matrizes de entrada e saída.
      n = 3'd4;

      
      // Teste 1 - Soma: 001
      $display("\nTeste 1: Soma (opcode 001)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b001;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("B = ");
      display_matrix(B_flat, n);
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);


      // Teste 2 - Subtração: 010
      $display("\nTeste 2: Subtração (opcode 010)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b010;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("B = ");
      display_matrix(B_flat, n);
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);


      // Teste 3 - Oposta: 100
      $display("\nTeste 3: Oposta (opcode 100)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b100;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);


      // Teste 4 - Oposta: 101
      $display("\nTeste 4: Transposta (opcode 101)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b101;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);


      // Teste 5 - Oposta: 011
      $display("\nTeste 5: Multiplicação (opcode 011)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b011;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("B = ");
      display_matrix(B_flat, n);
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);


      // Teste 6 - Produto por escalar: 110
      $display("\nTeste 6: Produto por escalar (opcode 110)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b110;
      // Valor escalar para realização de produto
      f = 8'b00000010;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("Valor = %d", $signed(f));
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);


      // Teste 7 - Determinante: 111
      $display("\nTeste 7: Determinante (opcode 111)");

      // Atualização do opcode - Sempre que o opcode alterar, realizamos uma operação.
      opcode = 3'b111;

      // O número após o # representa o número de ciclos
      #1;

      $display("A = ");
      display_matrix(A_flat, n);
      $display("C = ");
      display_matrix(C_flat, n);
      $display("Overflow Flag = %b", overflow_flag);




      $finish;
    end

endmodule