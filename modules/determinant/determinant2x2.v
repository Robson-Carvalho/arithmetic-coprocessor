// Módulo para cálculo do determinante de uma matriz 2x2 com elementos de 8 bits com sinal
module determinant2x2 (
    input [199:0] A_flat,                 // Vetor com os elementos da matriz 2x2 (e outros dados que não são usados aqui)
    input clock,                          // Clock para acionamento do processo síncrono
    output reg signed [7:0] det,          // Resultado final do determinante (valor com sinal)
    output reg done,                      // Sinalizador que indica que a operação foi concluída
    output reg overflow_flag              // Indicador de estouro (overflow) no resultado do determinante
);

    // Função auxiliar para multiplicação de dois números com sinal de 8 bits
    // Implementada manualmente com base em soma de deslocamentos condicionais
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;
        begin
            bit_mult = 0;
            if (b[0]) bit_mult = bit_mult + a;         // Se o bit 0 de b está ativo, soma a
            if (b[1]) bit_mult = bit_mult + (a << 1);  // Se o bit 1 está ativo, soma a << 1
            if (b[2]) bit_mult = bit_mult + (a << 2);  // a * 4
            if (b[3]) bit_mult = bit_mult + (a << 3);  // a * 8
            if (b[4]) bit_mult = bit_mult + (a << 4);  // a * 16
            if (b[5]) bit_mult = bit_mult + (a << 5);  // a * 32
            if (b[6]) bit_mult = bit_mult + (a << 6);  // a * 64
            if (b[7]) bit_mult = bit_mult - (a << 7);  // Se o bit de sinal está ativo, subtrai a * 128 (representa valor negativo)
        end
    endfunction

    // Registradores intermediários
    reg signed [7:0] a, b, c, d;           // Elementos da matriz 2x2: a, b, c, d
    reg signed [15:0] ad, bc;              // Produtos intermediários a*d e b*c
    reg signed [15:0] det_result;          // Resultado intermediário do determinante antes de truncar para 8 bits

    // Bloco combinacional: executado sempre que qualquer entrada mudar
    always @(*) begin
        // Conversão explícita de partes do vetor A_flat para valores com sinal
        a = $signed(A_flat[7:0]);          // Elemento a: posição 01
        b = $signed(A_flat[15:8]);         // Elemento b: posição 02
        c = $signed(A_flat[47:40]);        // Elemento c: posição 06
        d = $signed(A_flat[55:48]);        // Elemento d: posição 07
        
        // Calcula os produtos cruzados da matriz
        ad = bit_mult(a, d);               // a * d
        bc = bit_mult(b, c);               // b * c

        // Calcula o determinante: ad - bc
        det_result = ad - bc;
    end

    // Bloco sensível à borda de subida do clock
    // Atualiza as saídas com base no cálculo realizado
    always @(posedge clock) begin
        det <= det_result[7:0];                                // Armazena os 8 bits menos significativos do resultado (preserva o sinal)
        overflow_flag <= (det_result > 127) || (det_result < -128); // Verifica se o valor ultrapassa os limites de um inteiro de 8 bits com sinal
        done <= 1'b1;                                           // Sinaliza que a operação foi concluída
    end
endmodule
