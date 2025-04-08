module alu_multiplication_module (
    input signed [199:0] A_flat,   // Entrada: matriz A achatada (25 elementos de 8 bits com sinal)
    input signed [199:0] B_flat,   // Entrada: matriz B achatada (25 elementos de 8 bits com sinal)
    output [199:0] C_flat,         // Saída: matriz resultante C achatada (produto A x B)
    output overflow_flag           // Sinal de estouro (overflow) se algum valor exceder o intervalo [-128,127]
);

    wire [24:0] overflow;          // Vetor de flags de overflow para cada elemento da matriz resultante
    wire signed [15:0] temp [0:24]; // Armazena os valores intermediários do produto (16 bits para evitar estouro interno)

    genvar i, j, k;
    generate
        // Loop para cada linha da matriz A
        for (i = 0; i < 5; i = i + 1) begin : row_mult
            // Loop para cada coluna da matriz B
            for (j = 0; j < 5; j = j + 1) begin : col_mult
                wire signed [15:0] temp_sum;      // Soma parcial do produto escalar entre linha de A e coluna de B
                wire signed [15:0] prod [0:4];    // Vetor de produtos parciais para cada posição da linha-coluna

                // Loop para multiplicar elementos correspondentes da linha e coluna
                for (k = 0; k < 5; k = k + 1) begin : mult
                    wire signed [7:0] a_val = A_flat[(i*40) + (k*8) +: 8]; // Elemento A[i][k]
                    wire signed [7:0] b_val = B_flat[(k*40) + (j*8) +: 8]; // Elemento B[k][j]
                    assign prod[k] = bit_mult(a_val, b_val);              // Multiplica A[i][k] * B[k][j]
                end

                // Soma os produtos parciais para formar o elemento C[i][j]
                assign temp_sum = prod[0] + prod[1] + prod[2] + prod[3] + prod[4]; 
                assign temp[i*5 + j] = temp_sum;                           // Armazena o resultado no array temp

                assign C_flat[(i*40) + (j*8) +: 8] = temp[i*5 + j][7:0];   // Atribui os 8 bits menos significativos à saída

                assign overflow[i*5 + j] = (temp[i*5 + j] > 127) || (temp[i*5 + j] < -128); // Detecta overflow para este elemento
            end
        end
    endgenerate

    assign overflow_flag = |overflow; // Define overflow_flag se qualquer posição tiver overflow

    // Função auxiliar para multiplicação bit a bit (simulate multiplicação manual)
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;
        begin
            bit_mult = 0;
            if (b[0]) bit_mult = bit_mult + a;          // Soma a se o bit 0 de b for 1
            if (b[1]) bit_mult = bit_mult + (a << 1);   // Soma a << 1 se bit 1 de b for 1
            if (b[2]) bit_mult = bit_mult + (a << 2);   // Soma a << 2 se bit 2 de b for 1
            if (b[3]) bit_mult = bit_mult + (a << 3);   // Soma a << 3 se bit 3 de b for 1
            if (b[4]) bit_mult = bit_mult + (a << 4);   // Soma a << 4 se bit 4 de b for 1
            if (b[5]) bit_mult = bit_mult + (a << 5);   // Soma a << 5 se bit 5 de b for 1
            if (b[6]) bit_mult = bit_mult + (a << 6);   // Soma a << 6 se bit 6 de b for 1
            if (b[7]) bit_mult = bit_mult - (a << 7);   // Subtrai a << 7 se bit de sinal (b[7]) for 1 (para manter o sinal correto)
        end
    endfunction

endmodule
