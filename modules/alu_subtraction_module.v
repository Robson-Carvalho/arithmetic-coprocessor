module alu_subtraction_module(
  input [199:0] A_flat,         // Matriz A achatada (25 elementos de 8 bits)
  input [199:0] B_flat,         // Matriz B achatada (25 elementos de 8 bits)
  output [199:0] C_flat,        // Saída: resultado da subtração A - B (25 elementos)
  output overflow_flag          // Sinal de overflow: ativo se algum elemento teve overflow aritmético
);

  wire [24:0] overflow;         // Vetor que guarda os flags de overflow para cada subtração

  genvar i;
  generate
    // Gera a lógica para os 25 elementos da matriz
    for (i = 0; i < 25; i = i + 1) begin : process_elements
      
      // Extrai o i-ésimo elemento da matriz A e B como números com sinal
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];
      wire signed [7:0] b_val = B_flat[(i*8) +: 8];

      // Faz a subtração com extensão de sinal para 9 bits para detectar overflow
      wire [8:0] temp_sub = {1'b0, a_val} - {1'b0, b_val};

      // Armazena o resultado da subtração nos 8 bits menos significativos
      assign C_flat[(i*8) +: 8] = temp_sub[7:0];

      // Detecta overflow na subtração com sinal:
      // Quando os sinais de A e B são diferentes, e o resultado tem sinal oposto ao de A
      assign overflow[i] = (a_val[7] != b_val[7]) && (temp_sub[7] != a_val[7]);
    end
  endgenerate

  // Sinal de overflow geral: ativo se qualquer um dos elementos teve overflow
  assign overflow_flag = |overflow;

endmodule
