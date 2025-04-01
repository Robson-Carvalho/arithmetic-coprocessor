module alu_opposite_module(
  input [199:0] A_flat,       // Matriz de entrada (5x5, 200 bits)
  output [199:0] C_flat,      // Resultado da negação (5x5, 200 bits)
  output overflow_flag      // Flag de overflow
);

  // Sinal de overflow para cada elemento (25 elementos)
  wire [24:0] element_overflow;


  genvar i;
  generate
    for (i = 0; i < 25; i = i + 1) begin : negation
      // Extrai o valor de 8 bits com sinal
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];
      
      // Calcula o valor negado
      wire signed [7:0] neg_val = -a_val;
      
      // Armazena o resultado
      assign C_flat[(i*8) +: 8] = neg_val;

      // Detecção de overflow para este elemento
      // Overflow ocorre quando negamos -128 (pois 128 não cabe em 8 bits com sinal)
      assign element_overflow[i] = (a_val == 8'b10000000);
    end
  endgenerate

  // Overflow global (se qualquer elemento causou overflow)
  assign overflow_flag = |element_overflow;

endmodule