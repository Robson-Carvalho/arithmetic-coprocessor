module malu (
    input [199:0] A_flat,
    input [199:0] B_flat,
    input [2:0] n,
    input [8:0] f,
    input [3:0] opcode,
    output reg [199:0] C_flat
);
    reg signed [7:0] A [4:0][4:0];
    reg signed [7:0] B [4:0][4:0];
    reg signed [7:0] C [4:0][4:0];
    integer i, j, k;

    always @(opcode) begin
        C_flat = 200'b0;
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                A[i][j] = A_flat[(i*5 + j)*8 +: 8];
                B[i][j] = B_flat[(i*5 + j)*8 +: 8];
            end
        end

        case (opcode)
            // Soma
            4'b0001: begin
                for (i = 0; i < 5; i = i + 1) begin
                    for (j = 0; j < 5; j = j + 1) begin
                        // Soma de A e B
                        C_flat[8*(i + 5*j) +: 8] = A_flat[8*(i + 5*j) +: 8] + B_flat[8*(i + 5*j) +: 8];
                    end
                end
            end

            // Subtração
            4'b0010: begin
                for (i = 0; i < 5; i = i + 1) begin
                    for (j = 0; j < 5; j = j + 1) begin
                        // Subtração de A e B
                        C_flat[8*(i + 5*j) +: 8] = A_flat[8*(i + 5*j) +: 8] - B_flat[8*(i + 5*j) +: 8];
                    end
                end
            end

            // Multiplicação
            4'b0011: begin
              // Inicializa a matriz C (resultado) com zero
              for (i = 0; i < 5; i = i + 1) begin
                  for (j = 0; j < 5; j = j + 1) begin
                      C[i][j] = 0;  // Inicializa cada elemento de C com zero
                  end
              end

              // Lógica de multiplicação de matrizes
              for (i = 0; i < 5; i = i + 1) begin
                  for (j = 0; j < 5; j = j + 1) begin
                      for (k = 0; k < 5; k = k + 1) begin
                          // Realiza a multiplicação e soma dos elementos
                          C[i][j] = C[i][j] + (A[i][k] * B[k][j]);
                      end
                  end
              end

              // Agora, converte a matriz C para o formato `C_flat` (se necessário)
              for (i = 0; i < 5; i = i + 1) begin
                  for (j = 0; j < 5; j = j + 1) begin
                      // Atualiza a posição de C_flat considerando as linhas e colunas de C
                      C_flat[8*(i*5 + j) +: 8] = C[i][j];  // Armazena o valor de C na variável C_flat
                  end
              end
            end


            // Transposta
            4'b0100: begin
                for (i = 0; i < 5; i = i + 1) begin
                    for (j = 0; j < 5; j = j + 1) begin
                        C_flat[8*(i + 5*j) +: 8] = A_flat[8*(j + 5*i) +: 8]; 
                    end
                end
            end

            // Oposta
            4'b0101: begin
                C_flat[8*(0 + 5*0) +: 8] = -A_flat[8*(0 + 5*0) +: 8];
                C_flat[8*(1 + 5*0) +: 8] = -A_flat[8*(1 + 5*0) +: 8];
                C_flat[8*(2 + 5*0) +: 8] = -A_flat[8*(2 + 5*0) +: 8];
                C_flat[8*(3 + 5*0) +: 8] = -A_flat[8*(3 + 5*0) +: 8];
                C_flat[8*(4 + 5*0) +: 8] = -A_flat[8*(4 + 5*0) +: 8];

                C_flat[8*(0 + 5*1) +: 8] = -A_flat[8*(0 + 5*1) +: 8];
                C_flat[8*(1 + 5*1) +: 8] = -A_flat[8*(1 + 5*1) +: 8];
                C_flat[8*(2 + 5*1) +: 8] = -A_flat[8*(2 + 5*1) +: 8];
                C_flat[8*(3 + 5*1) +: 8] = -A_flat[8*(3 + 5*1) +: 8];
                C_flat[8*(4 + 5*1) +: 8] = -A_flat[8*(4 + 5*1) +: 8];

                C_flat[8*(0 + 5*2) +: 8] = -A_flat[8*(0 + 5*2) +: 8];
                C_flat[8*(1 + 5*2) +: 8] = -A_flat[8*(1 + 5*2) +: 8];
                C_flat[8*(2 + 5*2) +: 8] = -A_flat[8*(2 + 5*2) +: 8];
                C_flat[8*(3 + 5*2) +: 8] = -A_flat[8*(3 + 5*2) +: 8];
                C_flat[8*(4 + 5*2) +: 8] = -A_flat[8*(4 + 5*2) +: 8];

                C_flat[8*(0 + 5*3) +: 8] = -A_flat[8*(0 + 5*3) +: 8];
                C_flat[8*(1 + 5*3) +: 8] = -A_flat[8*(1 + 5*3) +: 8];
                C_flat[8*(2 + 5*3) +: 8] = -A_flat[8*(2 + 5*3) +: 8];
                C_flat[8*(3 + 5*3) +: 8] = -A_flat[8*(3 + 5*3) +: 8];
                C_flat[8*(4 + 5*3) +: 8] = -A_flat[8*(4 + 5*3) +: 8];

                C_flat[8*(0 + 5*4) +: 8] = -A_flat[8*(0 + 5*4) +: 8];
                C_flat[8*(1 + 5*4) +: 8] = -A_flat[8*(1 + 5*4) +: 8];
                C_flat[8*(2 + 5*4) +: 8] = -A_flat[8*(2 + 5*4) +: 8];
                C_flat[8*(3 + 5*4) +: 8] = -A_flat[8*(3 + 5*4) +: 8];
                C_flat[8*(4 + 5*4) +: 8] = -A_flat[8*(4 + 5*4) +: 8];
            end
				
				// Multiplicação por numero inteiro
            4'b0110: begin
            for (i = 0; i < 5; i = i + 1) begin
                for (j = 0; j < 5; j = j + 1) begin
                  
                  C_flat[(j * 5 + i) * 8 +: 8] = f * A_flat[(j * 5 + i) * 8 +: 8];
                end
              end
            end

            default: begin
                C_flat = 200'b0;
            end
        endcase
    end
endmodule
