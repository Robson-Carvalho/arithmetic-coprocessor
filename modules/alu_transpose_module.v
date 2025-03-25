module alu_transpose_module(
  input [199:0] A_flat,      // Matriz A achatada (200 bits)
  input [199:0] B_flat,      // Matriz B achatada (200 bits)
  output reg [199:0] C_flat, // Resultado da soma (200 bits)
  output reg overflow_flag,  // Flag de overflow
  output reg done            // Flag de finalização
);


endmodule
