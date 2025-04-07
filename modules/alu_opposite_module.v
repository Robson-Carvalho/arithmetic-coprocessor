module alu_opposite_module(
  input [199:0] A_flat,       // Entrada: matriz achatada A com 25 elementos de 8 bits
  output [199:0] C_flat       // Saída: matriz oposta de A, também achatada
);

  genvar i;
  generate
    // Geração de lógica para processar os 25 elementos da matriz
    for (i = 0; i < 25; i = i + 1) begin : negation
      
      // Extrai o valor do elemento i da matriz A com sinal
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];
      
      // Calcula o valor oposto (negativo) do elemento
      wire signed [7:0] neg_val = -a_val;
      
      // Atribui o valor negado à posição correspondente da matriz de saída
      assign C_flat[(i*8) +: 8] = neg_val;
    end
  endgenerate

endmodule
