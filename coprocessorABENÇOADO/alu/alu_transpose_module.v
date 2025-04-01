module alu_transpose_module(
  input [199:0] A_flat,      // Matriz A achatada (5x5, 200 bits)
  output [199:0] C_flat      // Resultado da transposta (5x5, 200 bits)
);

  // Como não há operações aritméticas, overflow_flag é sempre 0
  assign overflow_flag = 1'b0;
  
  // Operação é puramente combinacional, done sempre ativo
  assign done = 1'b1;

  // Conexões dos elementos transpostos usando generate
  genvar i, j;
  generate
    for (i = 0; i < 5; i = i + 1) begin : batata
      for (j = 0; j < 5; j = j + 1) begin : ddasydasd
        // C[i][j] = A[j][i]
        assign C_flat[(i*5 + j)*8 +: 8] = A_flat[(j*5 + i)*8 +: 8];
      end
    end
  endgenerate

endmodule