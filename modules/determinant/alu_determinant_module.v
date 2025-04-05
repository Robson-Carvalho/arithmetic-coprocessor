module alu_determinant_module (
    input wire clock,
    input wire [199:0] A_flat,
    output reg [7:0] number,
    output reg done,
    input wire [2:0] matrix_size,
    output reg overflow_flag
);

    wire [7:0] det_2x2;
    wire det_done;
    wire det_overflow;

    determinant2x2 det2x2 (
        .A_flat(A_flat[31:0]),
        .clock(clock),
        .det(det_2x2),
        .done(det_done),
        .overflow_flag(det_overflow)
    );

endmodule