module determinant5x5 (
    input [199:0] A_flat,
    input clock,
    output reg signed [7:0] det,
    output reg done,
    output reg overflow_flag
);

    // Função de multiplicação por deslocamento de bits
    function signed [15:0] bit_mult;
        input signed [7:0] a;
        input signed [7:0] b;
        reg signed [15:0] result;
        begin
            result = 0;
            if (b[0]) result = result + a;
            if (b[1]) result = result + (a << 1);
            if (b[2]) result = result + (a << 2);
            if (b[3]) result = result + (a << 3);
            if (b[4]) result = result + (a << 4);
            if (b[5]) result = result + (a << 5);
            if (b[6]) result = result + (a << 6);
            if (b[7]) result = result - (a << 7);
            bit_mult = result;
        end
    endfunction

    // Função determinante 3x3
    function signed [31:0] det3x3;
        input signed [7:0] a, b, c, d, e, f, g, h, i;
        reg signed [31:0] aei, bfg, cdh, ceg, bdi, afh;
        begin
            aei = bit_mult(a, bit_mult(e, i));
            bfg = bit_mult(b, bit_mult(f, g));
            cdh = bit_mult(c, bit_mult(d, h));
            ceg = bit_mult(c, bit_mult(e, g));
            bdi = bit_mult(b, bit_mult(d, i));
            afh = bit_mult(a, bit_mult(f, h));
            det3x3 = aei + bfg + cdh - ceg - bdi - afh;
        end
    endfunction

    // Função determinante 4x4
    function signed [31:0] det4x4;
        input signed [7:0] a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
        reg signed [31:0] det3x3_1, det3x3_2, det3x3_3, det3x3_4;
        reg signed [31:0] result;
        begin
            det3x3_1 = det3x3(f, g, h, j, k, l, n, o, p);
            det3x3_2 = det3x3(e, g, h, i, k, l, m, o, p);
            det3x3_3 = det3x3(e, f, h, i, j, l, m, n, p);
            det3x3_4 = det3x3(e, f, g, i, j, k, m, n, o);
            
            result = bit_mult(a, det3x3_1) - bit_mult(b, det3x3_2) + 
                    bit_mult(c, det3x3_3) - bit_mult(d, det3x3_4);
            det4x4 = result;
        end
    endfunction

    // Registradores para os elementos da matriz
    reg signed [7:0] a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y;
    reg signed [31:0] det_result;

    // Lógica combinacional para cálculo do determinante
    always @(*) begin
        // Extração dos elementos com conversão explícita para signed
        a = $signed(A_flat[7:0]);
        b = $signed(A_flat[15:8]);
        c = $signed(A_flat[23:16]);
        d = $signed(A_flat[31:24]);
        e = $signed(A_flat[39:32]);
        f = $signed(A_flat[47:40]);
        g = $signed(A_flat[55:48]);
        h = $signed(A_flat[63:56]);
        i = $signed(A_flat[71:64]);
        j = $signed(A_flat[79:72]);
        k = $signed(A_flat[87:80]);
        l = $signed(A_flat[95:88]);
        m = $signed(A_flat[103:96]);
        n = $signed(A_flat[111:104]);
        o = $signed(A_flat[119:112]);
        p = $signed(A_flat[127:120]);
        q = $signed(A_flat[135:128]);
        r = $signed(A_flat[143:136]);
        s = $signed(A_flat[151:144]);
        t = $signed(A_flat[159:152]);
        u = $signed(A_flat[167:160]);
        v = $signed(A_flat[175:168]);
        w = $signed(A_flat[183:176]);
        x = $signed(A_flat[191:184]);
        y = $signed(A_flat[199:192]);
        
        // Cálculo do determinante usando expansão por Laplace
        // Cálculo correto do determinante usando expansão por Laplace
det_result = 
    bit_mult(a, det4x4(
        // Submatriz excluindo linha 1 e coluna 1
        g, h, i, j,
        l, m, n, o,
        q, r, s, t,
        v, w, x, y
    )) -
    bit_mult(b, det4x4(
        // Submatriz excluindo linha 1 e coluna 2
        f, h, i, j,
        k, m, n, o,
        p, r, s, t,
        u, w, x, y
    )) +
    bit_mult(c, det4x4(
        // Submatriz excluindo linha 1 e coluna 3
        f, g, i, j,
        k, l, n, o,
        p, q, s, t,
        u, v, x, y
    )) -
    bit_mult(d, det4x4(
        // Submatriz excluindo linha 1 e coluna 4
        f, g, h, j,
        k, l, m, o,
        p, q, r, t,
        u, v, w, y
    )) +
    bit_mult(e, det4x4(
        // Submatriz excluindo linha 1 e coluna 5
        f, g, h, i,
        k, l, m, n,
        p, q, r, s,
        u, v, w, x
    ));
    end

    // Atualização dos registradores na borda de subida do clock
    always @(posedge clock) begin
        det <= det_result[7:0];
        overflow_flag <= (det_result > 127) || (det_result < -128);
        done <= 1'b1;
    end
endmodule