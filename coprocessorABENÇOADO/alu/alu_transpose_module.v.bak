module alu_transpose_module(
  input [199:0] A_flat,      // Matriz A achatada (5x5, 200 bits)
  output reg [199:0] C_flat, // Resultado da transposta (5x5, 200 bits)
  output reg overflow_flag,  // Flag de overflow
  output reg done            // Flag de finalização
);
  integer idx;               // Índice para percorrer os elementos
  integer i, j;              // Índices de linha e coluna

  always @(*) begin
    // Inicializa saídas
    C_flat = 200'b0;
    overflow_flag = 1'b0;    // Não há overflow em uma transposta
    done = 1'b0;

    // Percorre os 25 elementos da matriz
    for (idx = 0; idx < 25; idx = idx + 1) begin
      // Calcula índices i (linha) e j (coluna) a partir de idx
      i = idx / 5;  // Linha (0 a 4)
      j = idx % 5;  // Coluna (0 a 4)

      // C[i][j] = A[j][i]
      // Pega o elemento de A_flat na posição (j*5 + i) e coloca em (i*5 + j)
      C_flat[(i*5 + j)*8 +: 8] = A_flat[(j*5 + i)*8 +: 8];
    end

    // Sinaliza conclusão
    done = 1'b1;
  end
endmodule