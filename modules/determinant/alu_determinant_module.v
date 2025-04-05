module alu_determinant_module (
    input wire clock,
    input wire [199:0] A_flat,
    output reg [7:0] number,
    output reg done,
    input wire [2:0] matrix_size,
    output reg overflow_flag
);

    // Sinais para cada módulo de determinante
    wire [7:0] det_2x2, det_3x3, det_4x4, det_5x5;
    wire done_2x2, done_3x3, done_4x4, done_5x5;
    wire ovf_2x2, ovf_3x3, ovf_4x4, ovf_5x5;

    // Instanciação dos módulos
    determinant2x2 det2x2 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_2x2),
        .done(done_2x2),
        .overflow_flag(ovf_2x2)
    );

    determinant3x3 det3x3 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_3x3),
        .done(done_3x3),
        .overflow_flag(ovf_3x3)
    );

    determinant4x4 det4x4 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_4x4),
        .done(done_4x4),
        .overflow_flag(ovf_4x4)
    );

    determinant5x5 det5x5 (
        .A_flat(A_flat),
        .clock(clock),
        .det(det_5x5),
        .done(done_5x5),
        .overflow_flag(ovf_5x5)
    );

    // Lógica de seleção do determinante
    always @(*) begin
        case (matrix_size)
            3'b010: begin // 2x2
                number = det_2x2;
                done = done_2x2;
                overflow_flag = ovf_2x2;
            end
            3'b011: begin // 3x3
                number = det_3x3;
                done = done_3x3;
                overflow_flag = ovf_3x3;
            end
            3'b100: begin // 4x4
                number = det_4x4;
                done = done_4x4;
                overflow_flag = ovf_4x4;
            end
            3'b101: begin // 5x5
                number = det_5x5;
                done = done_5x5;
                overflow_flag = ovf_5x5;
            end
            default: begin
                number = 8'b0;
                done = 1'b0;
                overflow_flag = 1'b0;
            end
        endcase
    end
endmodule