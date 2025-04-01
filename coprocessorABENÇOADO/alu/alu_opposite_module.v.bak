module alu_opposite_module(
  input [199:0] A_flat,   // Matrizes de entrada para operação
  output reg [199:0] C_flat,  // Resultado da operação
  output reg overflow_flag,  // Flag de overflow
  output reg done           // Flag de finalização
);

  // Declaração de variáveis internas
  integer i;
  reg signed [7:0] a_val;

  always @(*) begin
    // Inicialização dos sinais de saída
    C_flat = 200'b0;
    overflow_flag = 1'b0;
    done = 1'b0;

    // Processar 25 elementos da matriz A (200 bits / 8 bits = 25)
    for (i = 0; i < 25; i = i + 1) begin
      // Extrair o valor de 8 bits da matriz A
      a_val = A_flat[(i*8) +: 8];

      // Trocar o sinal do valor
      C_flat[(i*8) +: 8] = -a_val;

      // Detecção de overflow: se o valor for maior que 127 ou menor que -128 (fora do alcance de 8 bits com sinal)
      if (a_val > 127 || a_val < -128) begin
        overflow_flag = 1'b1;
      end
    end

    // Sinalizando que a operação foi concluída
    done = 1'b1;
  end

endmodule
