module coprocessor(
    input clk,              // Clock da FPGA
    input reset_n,          // Reset ativo em 0
    input [31:0] num1,      // Primeiro número enviado pelo HPS
    input [31:0] num2,      // Segundo número enviado pelo HPS
    input [1:0] instruction, // Código da operação (1 = soma)
    output reg [31:0] result,  // Resultado da operação
    output reg ready       // Sinal de pronto (1 = resultado disponível)
);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            result <= 32'b0;
            ready <= 1'b0;
        end else if (ready == 0) begin // Só processa se a FPGA estiver livre
            case (instruction)
                2'b01: result <= num1 + num2; // Soma
                default: result <= 32'b0;     // Caso não reconheça a instrução
            endcase
            ready <= 1'b1; // Ativa o sinal de pronto após calcular
        end
    end

endmodule
