module determinant2x2 (
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

    reg signed [7:0] a, b, c, d;
    reg signed [15:0] ad, bc;
    reg signed [15:0] det_result;

    always @(*) begin
        // Conversão explícita para signed
        a = $signed(A_flat[7:0]);    // Posição 01
        b = $signed(A_flat[15:8]);   // Posição 02
        c = $signed(A_flat[47:40]);  // Posição 06
        d = $signed(A_flat[55:48]);  // Posição 07
        
        ad = bit_mult(a, d);
        bc = bit_mult(b, c);
        det_result = ad - bc;
    end

    always @(posedge clock) begin
        det <= det_result[7:0];  // A atribuição mantém o sinal
        overflow_flag <= (det_result > 127) || (det_result < -128);
        done <= 1'b1;
    end
endmodule