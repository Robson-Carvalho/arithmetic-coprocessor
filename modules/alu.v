module alu (
    // dados entrada
    input clock,
    input [2:0] opcode,
    input [2:0] matrix_size,
    input [199:0] A_flat,
    input [199:0] B_flat,
    input [7:0] scalar,

    // dados saída
    output reg [199:0] C_flat,
    output reg [7:0] number,


    // sinais
    output reg overflow_flag,
    output reg done
);

    // --- Declaração dos fios de saída de cada módulo ---
    wire [7:0] determinant_number;
    wire [199:0] sum_C, sub_C, mul_C, opposite_C, transpose_C, scalar_C;
    wire sum_ovf, sub_ovf, mul_ovf, scalar_ovf, determinant_ovf;
    wire determinant_done;

     // --- Instanciação dos módulos ---
     alu_determinant_module determinant (
        .clock(clock),
        .A_flat(A_flat),
        .matrix_size(matrix_size),
        .number(determinant_number),
        .overflow_flag(determinant_ovf),
        .done(determinant_done)
    );

    alu_sum_module sum (
        .A_flat(A_flat),
        .B_flat(B_flat),
        .C_flat(sum_C),
        .overflow_flag(sum_ovf)
    );

    alu_subtraction_module sub (
        .A_flat(A_flat),
        .B_flat(B_flat),
        .C_flat(sub_C),
        .overflow_flag(sub_ovf)
    );

    alu_multiplication_module mul (
        .A_flat(A_flat),
        .B_flat(B_flat),
        .C_flat(mul_C),
        .overflow_flag(mul_ovf)
    );

    alu_opposite_module opposite (
        .A_flat(A_flat),
        .C_flat(opposite_C)
    );

    alu_transpose_module transpose (
        .A_flat(A_flat),
        .C_flat(transpose_C)
    );

    alu_scalar_module scalar_mult (
        .A_flat(A_flat),
        .scalar(scalar),
        .C_flat(scalar_C),
        .overflow_flag(scalar_ovf)
    );


    // Sempre que o opcode for alterado, realiza-se a operação especificada
    always @(posedge clock) begin    
        C_flat = 200'b0;
        overflow_flag = 1'b0;
        done = 1'b0;

        case (opcode)
            3'b001: begin  // Soma
                C_flat = sum_C;
                overflow_flag = sum_ovf;
            end
            3'b010: begin  // Subtração
                C_flat = sub_C;
                overflow_flag = sub_ovf;
            end
            3'b011: begin  // Multiplicação
                C_flat <= mul_C;
                overflow_flag <= mul_ovf;
            end
            3'b100: begin  // Matriz oposta
                C_flat = opposite_C;
            end
            3'b101: begin  // Transposta
                C_flat = transpose_C;
            end
            3'b110: begin  // Produto por escalar
                C_flat = scalar_C;
                overflow_flag = scalar_ovf;
            end
            3'b111: begin  // Determinante
                number = determinant_number;
                overflow_flag = determinant_ovf;
                done = determinant_done;
            end
            default: begin // Caso inválido
                C_flat = 200'b0;
                overflow_flag = 1'b0;
                done = 1'b1;
            end
        endcase
    end

endmodule