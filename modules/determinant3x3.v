module determinant3x3 (
    input [199:0] A_flat,                // Entrada contendo os elementos da matriz 3x3 "achatada" (200 bits, mas apenas os primeiros são usados)
    input clock,                         // Clock para sincronizar a saída
    output reg signed [7:0] det,         // Saída do determinante com sinal (signed)
    output reg done,                     // Sinal indicando que a computação foi concluída
    output reg overflow_flag             // Sinal de estouro caso o determinante extrapole o intervalo de -128 a 127
);

    // Função auxiliar que realiza a multiplicação de dois números de 8 bits com sinal (signed)
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;
        begin
            bit_mult = 0;
            // Implementa a multiplicação bit a bit, tratando o sinal manualmente
            if (b[0]) bit_mult = bit_mult + a;
            if (b[1]) bit_mult = bit_mult + (a << 1);
            if (b[2]) bit_mult = bit_mult + (a << 2);
            if (b[3]) bit_mult = bit_mult + (a << 3);
            if (b[4]) bit_mult = bit_mult + (a << 4);
            if (b[5]) bit_mult = bit_mult + (a << 5);
            if (b[6]) bit_mult = bit_mult + (a << 6);
            if (b[7]) bit_mult = bit_mult - (a << 7);  // Trata o bit de sinal de forma correta
        end
    endfunction

    // Registros locais para armazenar os elementos da matriz
    reg signed [7:0] a, b, c, d, e, f, g, h, i;
    
    // Registros intermediários para armazenar multiplicações parciais
    reg signed [15:0] aei, bfg, cdh, ceg, bdi, afh;

    // Resultado final da expressão determinante
    reg signed [31:0] det_result;

    // Bloco sempre sensível a qualquer mudança (combinacional)
    always @(*) begin
        // Conversão explícita para signed de cada posição da matriz
        a = $signed(A_flat[7:0]);     // Linha 1, coluna 1
        b = $signed(A_flat[15:8]);    // Linha 1, coluna 2
        c = $signed(A_flat[23:16]);   // Linha 1, coluna 3
        d = $signed(A_flat[47:40]);   // Linha 2, coluna 1
        e = $signed(A_flat[55:48]);   // Linha 2, coluna 2
        f = $signed(A_flat[63:56]);   // Linha 2, coluna 3
        g = $signed(A_flat[87:80]);   // Linha 3, coluna 1
        h = $signed(A_flat[95:88]);   // Linha 3, coluna 2
        i = $signed(A_flat[103:96]);  // Linha 3, coluna 3

        // Calcula os produtos cruzados do determinante da matriz 3x3
        aei = bit_mult(a, bit_mult(e, i));
        bfg = bit_mult(b, bit_mult(f, g));
        cdh = bit_mult(c, bit_mult(d, h));
        ceg = bit_mult(c, bit_mult(e, g));
        bdi = bit_mult(b, bit_mult(d, i));
        afh = bit_mult(a, bit_mult(f, h));

        // Soma os termos positivos e subtrai os negativos conforme a regra do determinante 3x3
        det_result = aei + bfg + cdh - ceg - bdi - afh;
    end

    // Bloco sequencial (sensível à borda de subida do clock)
    always @(posedge clock) begin
        det <= det_result[7:0];  // Atribui somente os 8 bits menos significativos com sinal
        overflow_flag <= (det_result > 127) || (det_result < -128);  // Verifica se há overflow no intervalo de -128 a 127
        done <= 1'b1;  // Sinaliza que a operação foi concluída
    end
endmodule
