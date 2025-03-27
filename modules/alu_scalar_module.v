module alu_scalar_module (
  input [199:0] A_flat,          // Matriz de entrada achatada (5x5, 200 bits)
  input signed [7:0] scalar,     // Escalar de 8 bits (com sinal)
  output [199:0] C_flat,         // Resultado achatado (5x5, 200 bits)
  output overflow_flag           // Flag de overflow
);

  wire [24:0] overflow;  // Sinal de overflow para cada elemento

  genvar i;
  generate
    for (i = 0; i < 25; i = i + 1) begin : scalar_mult
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];  // Extrai cada elemento de 8 bits
      wire signed [7:0] temp_mult = a_val * scalar;  // Multiplicação com sinal (16 bits)

      // Atribui os 8 bits inferiores ao resultado
      assign C_flat[(i*8) +: 8] = temp_mult[7:0];

      // Detecção de overflow (verifica se o resultado não cabe em 8 bits)
      assign overflow[i] = (C_flat[(i*8) +: 8] > 127) ? 1'b1 : 1'b0;
    end
  endgenerate

  // Overflow global (se qualquer um dos 25 elementos estourou)
  assign overflow_flag = |overflow;
endmodule