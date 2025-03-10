module top(
    input [1:0] Key,    // Botões para ativar soma e subtração
    input [1:0] Sw,     // Chaves para selecionar linha e coluna
    output reg [7:0] Leds // LEDs para visualizar o resultado
);

    // Definição das fitas de bits para as matrizes A e B
    wire [31:0] A = 32'b00000000000000010000001000000000;
    wire [31:0] B = 32'b00000001000000100000000000000001;
    
    wire [31:0] sum_result;
    wire [31:0] sub_result;
    
    // Instancia os módulos de soma e subtração
    sum_operation sum_inst (
        .A(A),
        .B(B),
        .C(sum_result)
    );
    
    sub_operation sub_inst (
        .A(A),
        .B(B),
        .C(sub_result)
    );
    
    wire [31:0] result;
    
    // Seleciona a operação baseada no botão pressionado
    assign result = (Key[0]) ? sum_result :
                    (Key[1]) ? sub_result :
                    32'b0; // Nenhuma operação ativa
    
    // Seleção do elemento da matriz a ser mostrado nos LEDs
    always @(*) begin
        case ({Sw[1], Sw[0]})
            2'b00: Leds = result[7:0];   // Elemento [0][0]
            2'b01: Leds = result[15:8];  // Elemento [0][1]
            2'b10: Leds = result[23:16]; // Elemento [1][0]
            2'b11: Leds = result[31:24]; // Elemento [1][1]
            default: Leds = 8'b00000000; // Caso não definido
        endcase
    end

endmodule
