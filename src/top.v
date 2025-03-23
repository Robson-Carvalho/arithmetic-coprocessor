module top(
    input [2:0]Key,    // Botão que simula o clock
    input Sw,           // Chave do sinal start
    output Led
);

    // Definição das fitas de bits para as matrizes A, B e C
    wire [14:0] A = 15'b000000000000000;
    wire [14:0] B = 15'b100000001000000;
    wire [14:0] C = 15'b000000010101001;
    
    reg [14:0] instruc;
    reg [4:0] counter;
    wire clk_start;

    // Gerando um clock estável para o coprocessador
    assign clk_start = Key[0] & Sw; // Controle do clock, garantindo que o Sw ative a operação

    // Instância do coprocessador
    coprocessador coproc(
        .clk(clk_start),
        .reset(!Key[2]),
        .instruction(instruc),
        .erro(1),
        .done(Led), // Passando o sinal done para Led
        .result()
    );

    always @(posedge Key[1]) begin
        if (counter == 0) begin
            instruc = A;
            counter = counter + 1;
        end
        else if(counter == 1) begin
            instruc = B;
            counter = counter + 1;
        end
        else if(counter == 2) begin
            instruc = C;
            counter = counter + 1;
        end
    end

endmodule
