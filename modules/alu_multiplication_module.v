module alu_multiplication_module (
    input signed [199:0] A_flat,  // Matriz A achatada (5x5, 25 elementos de 8 bits com sinal)
    input signed [199:0] B_flat,  // Matriz B achatada (5x5, 25 elementos de 8 bits com sinal)
    input clock,
    output reg signed [199:0] C_flat = 0, // Inicializa como 0
    output reg overflow_flag,
    output reg done
);

    reg [2:0] row = 0;                // Contador de linhas (0 a 4)
    reg signed [15:0] temp [0:4];     // Resultados temporários

    always @(posedge clock) begin
        // Calcula os valores da linha atual
        temp[0] = (A_flat[(row*40) + 7 -: 8]   * B_flat[7:0])    +
                  (A_flat[(row*40) + 15 -: 8]  * B_flat[47:40])  +
                  (A_flat[(row*40) + 23 -: 8] * B_flat[87:80])  +
                  (A_flat[(row*40) + 31 -: 8] * B_flat[127:120]) +
                  (A_flat[(row*40) + 39 -: 8] * B_flat[167:160]);

        temp[1] = (A_flat[(row*40) + 7 -: 8]   * B_flat[15:8])   +
                  (A_flat[(row*40) + 15 -: 8]  * B_flat[55:48])  +
                  (A_flat[(row*40) + 23 -: 8] * B_flat[95:88])  +
                  (A_flat[(row*40) + 31 -: 8] * B_flat[135:128]) +
                  (A_flat[(row*40) + 39 -: 8] * B_flat[175:168]);

        temp[2] = (A_flat[(row*40) + 7 -: 8]   * B_flat[23:16])  +
                  (A_flat[(row*40) + 15 -: 8]  * B_flat[63:56])  +
                  (A_flat[(row*40) + 23 -: 8] * B_flat[103:96]) +
                  (A_flat[(row*40) + 31 -: 8] * B_flat[143:136]) +
                  (A_flat[(row*40) + 39 -: 8] * B_flat[183:176]);

        temp[3] = (A_flat[(row*40) + 7 -: 8]   * B_flat[31:24])  +
                  (A_flat[(row*40) + 15 -: 8]  * B_flat[71:64])  +
                  (A_flat[(row*40) + 23 -: 8] * B_flat[111:104]) +
                  (A_flat[(row*40) + 31 -: 8] * B_flat[151:144]) +
                  (A_flat[(row*40) + 39 -: 8] * B_flat[191:184]);

        temp[4] = (A_flat[(row*40) + 7 -: 8]   * B_flat[39:32])  +
                  (A_flat[(row*40) + 15 -: 8]  * B_flat[79:72])  +
                  (A_flat[(row*40) + 23 -: 8] * B_flat[119:112]) +
                  (A_flat[(row*40) + 31 -: 8] * B_flat[159:152]) +
                  (A_flat[(row*40) + 39 -: 8] * B_flat[199:192]);

        // Escreve os resultados em C_flat imediatamente
        C_flat[(row * 40) + 7 -: 8]  <= temp[0][7:0];
        C_flat[(row * 40) + 15 -: 8] <= temp[1][7:0];
        C_flat[(row * 40) + 23 -: 8] <= temp[2][7:0];
        C_flat[(row * 40) + 31 -: 8] <= temp[3][7:0];
        C_flat[(row * 40) + 39 -: 8] <= temp[4][7:0];

        // Verifica overflow
        overflow_flag <= (temp[0][15:8] != {8{temp[0][7]}}) ||
                         (temp[1][15:8] != {8{temp[1][7]}}) ||
                         (temp[2][15:8] != {8{temp[2][7]}}) ||
                         (temp[3][15:8] != {8{temp[3][7]}}) ||
                         (temp[4][15:8] != {8{temp[4][7]}});

        // Atualiza row e verifica conclusão
        if (row == 4) begin
            row <= 0;
            done <= 1;  // Sinaliza que o cálculo terminou
        end else begin
            row <= row + 1;
            done <= 0;
        end
    end
endmodule