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


        A_flat = 200'h01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01;
        B_flat = 200'h02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02_02;
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

// Testes de Determinante
    opcode = 3'b111;
    
    // Teste Determinante 2x2
    matrix_size = 3'b010;
    n = 3'b010;
    // Posição    25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01
    A_flat = 200'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_04_03_00_00_00_02_01;
    #100; 
    $display("\nDeterminante 2x2");
    $display("A = ");
    display_matrix(A_flat, n);
    $display("Determinante = %d", $signed(number));
    $display("Overflow Flag = %b", overflow_flag);

    // Teste Determinante 3x3
    matrix_size = 3'b011;
    n = 3'b011;
    // Posição    25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01
    A_flat = 200'h00_00_00_00_00_00_07_06_03_07_00_07_07_03_32_00_07_07_03_07_00_06_06_06_06;
    #100; 
    $display("\nDeterminante 3x3");
    $display("A = ");
    display_matrix(A_flat, n);
    $display("Determinante = %d", $signed(number));
    $display("Overflow Flag = %b", overflow_flag);

    // Teste Determinante 4x4
    matrix_size = 3'b100;
    n = 3'b100;
    // Posição    25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01
    A_flat = 200'h00_00_00_00_00_00_07_06_03_07_00_07_07_03_05_00_07_07_03_07_00_06_06_06_06;
    #100; 
    $display("\nDeterminante 4x4");
    $display("A = ");
    display_matrix(A_flat, n);
    $display("Determinante = %d", $signed(number));
    $display("Overflow Flag = %b", overflow_flag);

    // Teste Determinante 5x5
    matrix_size = 3'b101;
    n = 3'b101;
    // Posição    25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01
    A_flat = 200'h01_03_03_03_03_00_01_00_00_00_00_00_03_00_00_00_00_00_01_00_02_02_02_02_32;
    //A_flat = 200'h01_03_03_03_03_00_01_00_00_00_00_00_03_00_00_00_00_00_01_00_02_02_02_02_0A;
    #100; 
    $display("\nDeterminante 5x5");
    $display("A = ");
    display_matrix(A_flat, n);
    $display("Determinante = %d", $signed(number));
    $display("Overflow Flag = %b", overflow_flag);
    
    $finish;
    end
endmodule