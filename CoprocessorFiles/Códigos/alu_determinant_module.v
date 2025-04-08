// Módulo ALU que seleciona qual módulo de determinante usar baseado no tamanho da matriz
module alu_determinant_module (
    input wire clock,                     // Sinal de clock
    input wire [199:0] A_flat,            // Vetor linear com elementos da matriz (até 5x5)
    output reg [7:0] number,              // Resultado final do determinante (sem sinal aqui)
    output reg done,                      // Sinal de conclusão da operação
    input wire [2:0] matrix_size,         // Tamanho da matriz (ex: 3'b010 para 2x2, 3'b011 para 3x3, etc.)
    output reg overflow_flag              // Flag de overflow do cálculo
);

    // Sinais internos para os módulos de determinante
    wire [7:0] det_2x2, det_3x3, det_4x4, det_5x5;  // Resultados de cada módulo
    wire done_2x2, done_3x3, done_4x4, done_5x5;    // Sinais de conclusão de cada módulo
    wire ovf_2x2, ovf_3x3, ovf_4x4, ovf_5x5;        // Flags de overflow de cada módulo


    // Instanciação do módulo de determinante para matriz 2x2
    determinant2x2 det2x2 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_2x2),
        .done(done_2x2),
        .overflow_flag(ovf_2x2)
    );

    // Instanciação do módulo de determinante para matriz 3x3
    determinant3x3 det3x3 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_3x3),
        .done(done_3x3),
        .overflow_flag(ovf_3x3)
    );

    // Instanciação do módulo de determinante para matriz 4x4
    determinant4x4 det4x4 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_4x4),
        .done(done_4x4),
        .overflow_flag(ovf_4x4)
    );

    // Instanciação do módulo de determinante para matriz 5x5
    determinant5x5 det5x5 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_5x5),
        .done(done_5x5),
        .overflow_flag(ovf_5x5)
    );

    
    // Bloco sempre sensível a qualquer mudança: seleciona qual resultado usar baseado no tamanho da matriz
    always @(matrix_size) begin
        case (matrix_size)
            3'b010: begin // Caso seja matriz 2x2
                number = det_2x2;            // Usa o determinante calculado pelo módulo 2x2
                done = done_2x2;             // Sinal de pronto do módulo 2x2
                overflow_flag = ovf_2x2;     // Overflow do módulo 2x2
            end
            3'b011: begin // Caso seja matriz 3x3
                number = det_3x3;
                done = done_3x3;
                overflow_flag = ovf_3x3;
            end
            3'b100: begin // Caso seja matriz 4x4
                number = det_4x4;
                done = done_4x4;
                overflow_flag = ovf_4x4;
            end
            3'b101: begin // Caso seja matriz 5x5
                number = det_5x5;
                done = done_5x5;
                overflow_flag = ovf_5x5;
            end
            default: begin // Qualquer outro valor: resultado padrão zerado
                number = 8'b0;
                done = 1'b0;
                overflow_flag = 1'b0;
            end
        endcase
    end
endmodule