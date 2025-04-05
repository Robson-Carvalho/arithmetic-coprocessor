module alu_opposite_module(
  input [199:0] A_flat,       // Matriz de entrada (5x5, 200 bits)
  output [199:0] C_flat     // Resultado da negação (5x5, 200 bits)
);

  genvar i;
  generate
    for (i = 0; i < 25; i = i + 1) begin : negation
      // Extrai o valor de 8 bits com sinal
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];
      
      // Calcula o valor negado
      wire signed [7:0] neg_val = -a_val;
      
      // Armazena o resultado
      assign C_flat[(i*8) +: 8] = neg_val;
    end
  endgenerate
endmodule