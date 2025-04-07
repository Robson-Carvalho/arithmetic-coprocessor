module alu_scalar_module (
  input [199:0] A_flat,            // Entrada: matriz A achatada (25 elementos de 8 bits)
  input signed [7:0] scalar,       // Escalar com sinal que será multiplicado por cada elemento da matriz A
  output [199:0] C_flat,           // Saída: matriz resultante da multiplicação (também achatada)
  output overflow_flag             // Sinal de overflow: indica se houve overflow em alguma multiplicação
);

  wire [24:0] overflow;            // Vetor com flags de overflow para cada elemento da matriz

  genvar i;
  generate
    // Geração da lógica de multiplicação escalar para os 25 elementos
    for (i = 0; i < 25; i = i + 1) begin : scalar_mult
      // Extrai o valor do elemento i da matriz A como número com sinal
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];

      // Multiplica o valor por um escalar (resultado pode ter até 16 bits)
      wire signed [15:0] temp_mult = a_val * scalar;

      // Atribui os 8 bits menos significativos do resultado para a saída
      assign C_flat[(i*8) +: 8] = temp_mult[7:0];

      // Detecta overflow: verifica se os bits mais significativos do resultado
      // são iguais à extensão do bit de sinal (para garantir que o valor cabe em 8 bits)
      assign overflow[i] = (temp_mult[15:8] != {8{temp_mult[7]}}) ? 1'b1 : 1'b0;
    end
  endgenerate

  // O sinal de overflow geral será ativo se qualquer um dos elementos tiver tido overflow
  assign overflow_flag = |overflow;

endmodule
