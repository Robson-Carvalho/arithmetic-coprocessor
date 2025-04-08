module determinant4x4 (
    input [199:0] A_flat,               // Entrada com os valores da matriz "flattened" (25 elementos de 8 bits)
    input clock,                        // Clock do sistema
    output reg signed [7:0] det,        // Saída do determinante (reduzido para 8 bits com sinal)
    output reg done,                    // Sinaliza que o cálculo foi concluído
    output reg overflow_flag            // Indica se houve overflow no valor do determinante
);

    // Função de multiplicação simulando multiplicação por somas e deslocamentos (bit a bit)
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;        // Entradas com sinal de 8 bits
        begin
            bit_mult = 0;               // Inicializa o acumulador
            if (b[0]) bit_mult = bit_mult + a;
            if (b[1]) bit_mult = bit_mult + (a << 1);
            if (b[2]) bit_mult = bit_mult + (a << 2);
            if (b[3]) bit_mult = bit_mult + (a << 3);
            if (b[4]) bit_mult = bit_mult + (a << 4);
            if (b[5]) bit_mult = bit_mult + (a << 5);
            if (b[6]) bit_mult = bit_mult + (a << 6);
            if (b[7]) bit_mult = bit_mult - (a << 7); // Trata o bit de sinal para b negativo
        end
    endfunction

    // Função para cálculo do determinante de uma matriz 3x3 usando a regra de Sarrus
    function signed [31:0] det3x3;
        input signed [7:0] a, b, c, d, e, f, g, h, i; // Entradas da matriz 3x3
        reg signed [31:0] aei, bfg, cdh, ceg, bdi, afh;
        begin
            aei = bit_mult(a, bit_mult(e, i));
            bfg = bit_mult(b, bit_mult(f, g));
            cdh = bit_mult(c, bit_mult(d, h));
            ceg = bit_mult(c, bit_mult(e, g));
            bdi = bit_mult(b, bit_mult(d, i));
            afh = bit_mult(a, bit_mult(f, h));
            det3x3 = aei + bfg + cdh - ceg - bdi - afh; // Fórmula clássica do determinante 3x3
        end
    endfunction

    // Registradores locais para armazenar os elementos da matriz 4x4
    reg signed [7:0] a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
    reg signed [31:0] det_result; // Registrador para armazenar o determinante com maior largura

    // Bloco combinacional que extrai e converte os valores da matriz de forma assinada
    always @(*) begin
        // Extração com conversão explícita para signed
        a = $signed(A_flat[7:0]);     // Posição 01
        b = $signed(A_flat[15:8]);    // Posição 02
        c = $signed(A_flat[23:16]);   // Posição 03
        d = $signed(A_flat[31:24]);   // Posição 04
        e = $signed(A_flat[47:40]);   // Posição 06
        f = $signed(A_flat[55:48]);   // Posição 07
        g = $signed(A_flat[63:56]);   // Posição 08
        h = $signed(A_flat[71:64]);   // Posição 09
        i = $signed(A_flat[87:80]);   // Posição 11
        j = $signed(A_flat[95:88]);   // Posição 12
        k = $signed(A_flat[103:96]);  // Posição 13
        l = $signed(A_flat[111:104]); // Posição 14
        m = $signed(A_flat[127:120]); // Posição 16
        n = $signed(A_flat[135:128]); // Posição 17
        o = $signed(A_flat[143:136]); // Posição 18
        p = $signed(A_flat[151:144]); // Posição 19

        // Expansão do determinante da matriz 4x4 (cofatores da primeira linha)
        det_result = 
        bit_mult(a, det3x3(f, g, h, j, k, l, n, o, p)) -
        bit_mult(b, det3x3(e, g, h, i, k, l, m, o, p)) +
        bit_mult(c, det3x3(e, f, h, i, j, l, m, n, p)) -
        bit_mult(d, det3x3(e, f, g, i, j, k, m, n, o));
    end

    // Bloco sequencial acionado pela borda de subida do clock
    always @(posedge clock) begin
        det <= det_result[7:0];                                // Atribui apenas os 8 bits menos significativos
        overflow_flag <= (det_result > 127) || (det_result < -128); // Verifica se houve overflow
        done <= 1'b1;                                           // Indica que o cálculo foi concluído
    end
endmodule