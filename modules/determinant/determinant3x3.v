module determinant3x3 (
    input [199:0] A_flat,
    input clock,
    output reg signed [7:0] det,  // Agora declarado como signed
    output reg done,
    output reg overflow_flag
);
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;
        begin
            bit_mult = 0;
            if (b[0]) bit_mult = bit_mult + a;
            if (b[1]) bit_mult = bit_mult + (a << 1);
            if (b[2]) bit_mult = bit_mult + (a << 2);
            if (b[3]) bit_mult = bit_mult + (a << 3);
            if (b[4]) bit_mult = bit_mult + (a << 4);
            if (b[5]) bit_mult = bit_mult + (a << 5);
            if (b[6]) bit_mult = bit_mult + (a << 6);
            if (b[7]) bit_mult = bit_mult - (a << 7);  // Tratamento correto do bit de sinal
        end
    endfunction

    reg signed [7:0] a, b, c, d, e, f, g, h, i;
    reg signed [15:0] aei, bfg, cdh, ceg, bdi, afh;
    reg signed [31:0] det_result;

    always @(*) begin
        // Extrai os elementos com conversão explícita para signed
        a = $signed(A_flat[7:0]);     // Posição 01
        b = $signed(A_flat[15:8]);    // Posição 02
        c = $signed(A_flat[23:16]);   // Posição 03
        d = $signed(A_flat[47:40]);   // Posição 06
        e = $signed(A_flat[55:48]);   // Posição 07
        f = $signed(A_flat[63:56]);   // Posição 08
        g = $signed(A_flat[87:80]);   // Posição 11
        h = $signed(A_flat[95:88]);   // Posição 12
        i = $signed(A_flat[103:96]);  // Posição 13
        
        // Usa bit_mult para todas as multiplicações
        aei = bit_mult(a, bit_mult(e, i));
        bfg = bit_mult(b, bit_mult(f, g));
        cdh = bit_mult(c, bit_mult(d, h));
        ceg = bit_mult(c, bit_mult(e, g));
        bdi = bit_mult(b, bit_mult(d, i));
        afh = bit_mult(a, bit_mult(f, h));
        
        det_result = aei + bfg + cdh - ceg - bdi - afh;
    end

    always @(posedge clock) begin
        det <= det_result[7:0];  // Mantém a interpretação signed
        overflow_flag <= (det_result > 127) || (det_result < -128);
        done <= 1'b1;
    end
endmodule