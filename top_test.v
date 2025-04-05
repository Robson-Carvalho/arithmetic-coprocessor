module top_test();
    reg [199:0] A_flat;
    reg [199:0] B_flat;
    wire [199:0] C_flat;
    wire [7:0] number;
    reg [2:0] matrix_size;
    reg [2:0] n;
    reg [7:0] scalar;
    reg [2:0] opcode;
    reg clock;
    wire overflow_flag; 
    wire done;

    initial begin
        clock = 0;
        forever begin
            #10 clock = ~clock; // Período de 20 unidades
        end
    end

    alu module_alu (
        .A_flat(A_flat),
        .B_flat(B_flat),
        .scalar(scalar),
        .opcode(opcode),
        .clock(clock),
        .C_flat(C_flat),
        .matrix_size(matrix_size),
        .number(number),
        .overflow_flag(overflow_flag),
        .done(done)
    );

    task display_matrix;
        input [199:0] matrix;
        input [2:0] size;
        integer r, c;
        begin
            for (r = 0; r < size; r = r + 1) begin
                $write("[");
                for (c = 0; c < size; c = c + 1) begin
                    $write("%d", $signed(matrix[(r*5 + c)*8 +: 8]));
                    if (c < size - 1) $write(" ");
                end
                $display("]");
            end
        end
    endtask

    initial begin
        // Posição    25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01
        A_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_01_00_00_00_00_00_02_02_00_03_40_02_E4;
        B_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_01_00_00_00_00_00_02_02_00_CF_00_02_00;
        n = 3'b101;

        opcode = 3'b001;
        #20; 
        $display("\nSoma");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);

        opcode = 3'b010;
        #20; 
        $display("\nSubtração");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);

        opcode = 3'b011;
        #20; 
        $display("\nMultiplicação");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);

        opcode = 3'b100;
        #20; 
        $display("\nOposta");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);

        opcode = 3'b101;
        #20; 
        $display("\nTransposta");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);

        opcode = 3'b110;
        scalar = 8'b00000010;
        #20; 
        $display("\nEscalar");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Escalar = %d", scalar);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);

        opcode = 3'b111;
        matrix_size = 3'b010;
        #20; 
        $display("\nDeterminante");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", number);
        $display("Overflow Flag = %b", overflow_flag);
        $finish;
    end
endmodule