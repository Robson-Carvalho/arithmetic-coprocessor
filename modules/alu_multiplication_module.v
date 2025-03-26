module alu_multiplication_module(
  input [199:0] A_flat,          // Matriz A achatada (5x5, 200 bits)
  input [199:0] B_flat,          // Matriz B achatada (5x5, 200 bits)
  output reg [199:0] C_flat,     // Matriz resultado C achatada (5x5, 200 bits)
  output reg overflow_flag,      // Flag de overflow
  output reg done                // Flag de conclusão
);
  integer idx;                   // Índice único para percorrer os 25 elementos
  reg signed [7:0] a_val, b_val; // Valores temporários de 8 bits
  reg signed [15:0] temp_mult;   // Resultado temporário da multiplicação (16 bits)
  reg signed [15:0] temp_sum;    // Acumulador temporário para soma dos produtos
  integer i, j, k;               // Índices implícitos calculados a partir de idx

  always @(*) begin
    // Inicializa saídas
    C_flat = 200'b0;
    overflow_flag = 1'b0;
    done = 1'b0;

    // Processa os 25 elementos de C_flat com um único loop
    for (idx = 0; idx < 25; idx = idx + 1) begin
      // Calcula os índices i (linha) e j (coluna) a partir de idx
      i = idx / 5;  // Linha de C (0 a 4)
      j = idx % 5;  // Coluna de C (0 a 4)
      
      // Reseta o acumulador para o elemento C[i][j]
      temp_sum = 16'b0;

      // Calcula C[i][j] = soma de A[i][k] * B[k][j] para k = 0 a 4
      for (k = 0; k < 5; k = k + 1) begin
        // Extrai A[i][k]
        a_val = A_flat[(i*5 + k)*8 +: 8];
        // Extrai B[k][j]
        b_val = B_flat[(k*5 + j)*8 +: 8];
        // Multiplica
        temp_mult = a_val * b_val;
        // Acumula
        temp_sum = temp_sum + temp_mult;

        // Verifica overflow na soma
        if ((temp_mult[15] == 0 && temp_sum[15] == 1 && a_val[7] == 0 && b_val[7] == 0) || 
            (temp_mult[15] == 1 && temp_sum[15] == 0 && a_val[7] == 1 && b_val[7] == 1))
          overflow_flag = 1'b1;
      end

      // Atribui os 8 bits menos significativos ao elemento correspondente de C_flat
      C_flat[(idx*8) +: 8] = temp_sum[7:0];
    end

    // Sinaliza conclusão
    done = 1'b1;
  end
endmodule