module alu_sum_module(
  input [199:0] A_flat,          // Matriz A achatada (25 elementos de 8 bits)
  input [199:0] B_flat,          // Matriz B achatada (25 elementos de 8 bits)
  output [199:0] C_flat,         // Resultado da soma entre A e B (também 25 elementos)
  output overflow_flag           // Sinal de overflow: ativo se algum elemento teve overflow aritmético
);

  wire [24:0] overflow;          // Vetor para armazenar o overflow de cada uma das 25 somas

  genvar i;
  generate
    // Laço para processar todos os 25 elementos da matriz
    for (i = 0; i < 25; i = i + 1) begin : process_elements

      // Extrai o valor do elemento i de A e B, como valores com sinal (signed)
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];
      wire signed [7:0] b_val = B_flat[(i*8) +: 8];

      // Soma os dois valores com sinal, estendendo para 9 bits para detectar overflow
      wire [8:0] temp_sum = {1'b0, a_val} + {1'b0, b_val};

      // Atribui os 8 bits menos significativos do resultado à saída C_flat
      assign C_flat[(i*8) +: 8] = temp_sum[7:0];

      // Detecta overflow de soma com sinal:
      // Se dois positivos geram negativo, ou dois negativos geram positivo
      assign overflow[i] = (a_val[7] == 0 && b_val[7] == 0 && temp_sum[7] == 1) ||
                           (a_val[7] == 1 && b_val[7] == 1 && temp_sum[7] == 0);
    end
  endgenerate

  // O sinal de overflow_flag é ativado se qualquer posição do vetor overflow for 1
  assign overflow_flag = |overflow;
endmodule
