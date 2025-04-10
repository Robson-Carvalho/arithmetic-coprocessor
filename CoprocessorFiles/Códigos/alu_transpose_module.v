module alu_transpose_module(
  input [199:0] A_flat,         // Entrada: matriz A achatada (5x5 elementos de 8 bits = 200 bits)
  output [199:0] C_flat         // Saída: matriz transposta de A, também achatada
);

  // Declaração de variáveis para gerar laços
  genvar i, j;
  generate
    // Geração dos índices para transposição de matriz 5x5
    for (i = 0; i < 5; i = i + 1) begin : roow
      for (j = 0; j < 5; j = j + 1) begin : col
        // Cada elemento da saída C recebe o valor transposto da entrada A
        assign C_flat[(i*5 + j)*8 +: 8] = A_flat[(j*5 + i)*8 +: 8];
        // Exemplo: C[linha][coluna] = A[coluna][linha]
      end
    end
  endgenerate

endmodule
