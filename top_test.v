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
            #10 clock = ~clock; // Period of 20 time units
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
        // Test all operations for each matrix size (2x2 to 5x5)
        
        // ========== 2x2 Matrix Tests ==========
        $display("\n\n===== 2x2 Matrix Tests =====");
        n = 3'b010;
        matrix_size = 3'b010;
        
        // Test case 1 for 2x2
        A_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_04_03_00_00_00_02_01;
        B_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_01_FF_00_00_00_05_02;
        
        // Addition
        opcode = 3'b001;
        #20;
        $display("\n2x2 Addition Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Subtraction
        opcode = 3'b010;
        #20;
        $display("\n2x2 Subtraction Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Multiplication
        opcode = 3'b011;
        #20;
        $display("\n2x2 Multiplication Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Opposite
        opcode = 3'b100;
        #20;
        $display("\n2x2 Opposite Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Transpose
        opcode = 3'b101;
        #20;
        $display("\n2x2 Transpose Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Scalar Multiplication
        opcode = 3'b110;
        scalar = 8'd3;
        #20;
        $display("\n2x2 Scalar Multiplication Test 1 (Scalar = 3)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Determinant
        opcode = 3'b111;
        #100;
        $display("\n2x2 Determinant Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        // Test case 2 for 2x2 (edge cases)
        A_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_80_7F_00_00_00_FF_01;
        B_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_01_01_00_00_00_01_01;
        
        // Addition (overflow test)
        opcode = 3'b001;
        #20;
        $display("\n2x2 Addition Test 2 (Overflow)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // ========== 3x3 Matrix Tests ==========
        $display("\n\n===== 3x3 Matrix Tests =====");
        n = 3'b011;
        matrix_size = 3'b011;
        
        // Test case 1 for 3x3
        A_flat = 200'h00_00_00_00_00_00_07_06_03_07_00_07_07_03_32_00_07_07_03_07_00_06_06_06_06;
        B_flat = 200'h00_00_00_00_00_00_01_02_03_04_00_05_06_07_08_00_09_0A_0B_0C_00_0D_0E_0F_10;
        
        // Addition
        opcode = 3'b001;
        #20;
        $display("\n3x3 Addition Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Subtraction
        opcode = 3'b010;
        #20;
        $display("\n3x3 Subtraction Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Multiplication
        opcode = 3'b011;
        #20;
        $display("\n3x3 Multiplication Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Opposite
        opcode = 3'b100;
        #20;
        $display("\n3x3 Opposite Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Transpose
        opcode = 3'b101;
        #20;
        $display("\n3x3 Transpose Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Scalar Multiplication
        opcode = 3'b110;
        scalar = 8'd4;
        #20;
        $display("\n3x3 Scalar Multiplication Test 1 (Scalar = 4)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Determinant
        opcode = 3'b111;
        #100;
        $display("\n3x3 Determinant Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        // Test case 2 for 3x3 (identity matrix)
        A_flat = 200'h00_00_00_00_00_00_00_00_01_00_00_00_01_00_00_00_00_01_00_00_00_00_00_00_01;
        
        // Determinant of identity matrix should be 1
        opcode = 3'b111;
        #100;
        $display("\n3x3 Determinant Test 2 (Identity Matrix)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        // ========== 4x4 Matrix Tests ==========
        $display("\n\n===== 4x4 Matrix Tests =====");
        n = 3'b100;
        matrix_size = 3'b100;
        
        // Test case 1 for 4x4
        A_flat = 200'h00_00_00_00_00_00_07_06_03_07_00_07_07_03_05_00_07_07_03_07_00_06_06_06_06;
        B_flat = 200'h00_00_00_00_00_00_01_02_03_04_00_05_06_07_08_00_09_0A_0B_0C_00_0D_0E_0F_10;
        
        // Addition
        opcode = 3'b001;
        #20;
        $display("\n4x4 Addition Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Subtraction
        opcode = 3'b010;
        #20;
        $display("\n4x4 Subtraction Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Multiplication
        opcode = 3'b011;
        #20;
        $display("\n4x4 Multiplication Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Opposite
        opcode = 3'b100;
        #20;
        $display("\n4x4 Opposite Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Transpose
        opcode = 3'b101;
        #20;
        $display("\n4x4 Transpose Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Scalar Multiplication
        opcode = 3'b110;
        scalar = 8'd2;
        #20;
        $display("\n4x4 Scalar Multiplication Test 1 (Scalar = 2)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Determinant
        opcode = 3'b111;
        #100;
        $display("\n4x4 Determinant Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        // Test case 2 for 4x4 (with zeros)
        A_flat = 200'h00_00_00_00_00_00_00_00_00_0A_00_00_0B_00_0C_00_00_0D_00_0E_00_0F_00_00_00;
        
        // Determinant
        opcode = 3'b111;
        #100;
        $display("\n4x4 Determinant Test 2 (Sparse Matrix)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        // ========== 5x5 Matrix Tests ==========
        $display("\n\n===== 5x5 Matrix Tests =====");
        n = 3'b101;
        matrix_size = 3'b101;
        
        // Test case 1 for 5x5
        A_flat = 200'h01_03_03_03_03_00_01_00_00_00_00_00_03_00_00_00_00_00_01_00_02_02_02_02_32;
        B_flat = 200'h01_02_03_04_05_00_06_07_08_09_00_0A_0B_0C_0D_00_0E_0F_10_11_00_12_13_14_15;
        
        // Addition
        opcode = 3'b001;
        #20;
        $display("\n5x5 Addition Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Subtraction
        opcode = 3'b010;
        #20;
        $display("\n5x5 Subtraction Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Multiplication
        opcode = 3'b011;
        #20;
        $display("\n5x5 Multiplication Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Opposite
        opcode = 3'b100;
        #20;
        $display("\n5x5 Opposite Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Transpose
        opcode = 3'b101;
        #20;
        $display("\n5x5 Transpose Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        
        // Scalar Multiplication
        opcode = 3'b110;
        scalar = 8'd5;
        #20;
        $display("\n5x5 Scalar Multiplication Test 1 (Scalar = 5)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);
        
        // Determinant
        opcode = 3'b111;
        #100;
        $display("\n5x5 Determinant Test 1");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        // Test case 2 for 5x5 (triangular matrix)
        A_flat = 200'h01_02_03_04_05_00_06_07_08_09_00_00_0A_0B_0C_00_00_00_0D_0E_00_00_00_00_0F;
        
        // Determinant (should be product of diagonal)
        opcode = 3'b111;
        #100;
        $display("\n5x5 Determinant Test 2 (Triangular Matrix)");
        $display("A = ");
        display_matrix(A_flat, n);
        $display("Determinante = %d", $signed(number));
        $display("Overflow Flag = %b", overflow_flag);
        
        $finish;
    end
endmodule