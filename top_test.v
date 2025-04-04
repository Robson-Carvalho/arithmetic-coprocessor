module top_test();
    reg [199:0] A_flat;
    reg [199:0] B_flat;
    wire [199:0] C_flat;
    reg [2:0] n;
    reg [7:0] f;
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
        .f(f),
        .opcode(opcode),
        .clock(clock),
        .C_flat(C_flat),
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
        // A_flat = 200'h07070707070707070707070707060509010203040604030203; 
        // B_flat = 200'h0000000000000000000000000000000000000000FEFC00FD00;
        A_flat = 200'h000000000000000000000000000000000000000A0000000014; // trocar 14 por 0A para não ter overflow.
        B_flat = 200'h00000000000000000000000000000000000000000000000008;
        n = 3'b011;

        // // Teste 6 - Produto por escalar: 110
        // $display("\nTeste 6: Produto por escalar (opcode 110)");
        // opcode = 3'b110;
        // f = 8'b00000010;
        // #20; // Espera 1 ciclo completo
        // $display("A = ");
        // display_matrix(A_flat, n);
        // $display("Valor = %d", $signed(f));
        // $display("C = ");
        // display_matrix(C_flat, n);
        // $display("Overflow Flag = %b", overflow_flag);

        // // Teste 1 - Soma: 001
        // $display("\nTeste 1: Soma (opcode 001)");
        // opcode = 3'b001;
        // #20; // Espera 1 ciclo completo
        // $display("A = ");
        // display_matrix(A_flat, n);
        // $display("B = ");
        // display_matrix(B_flat, n);
        // $display("C = ");
        // display_matrix(C_flat, n);
        // $display("Overflow Flag = %b", overflow_flag);

        // // Teste 2 - Subtração: 010
        // $display("\nTeste 2: Subtração (opcode 010)");
        // opcode = 3'b010;
        // #20; // Espera 1 ciclo completo
        // $display("A = ");
        // display_matrix(A_flat, n);
        // $display("B = ");
        // display_matrix(B_flat, n);
        // $display("C = ");
        // display_matrix(C_flat, n);
        // $display("Overflow Flag = %b", overflow_flag);

        // Teste 3 - Oposta: 100
        $display("\nTeste 3: Oposta (opcode 100)");
        opcode = 3'b100;
        #20; // Espera 1 ciclo completo
        $display("A = ");
        display_matrix(A_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);

        // // Teste 4 - Transposta: 101
        // $display("\nTeste 4: Transposta (opcode 101)");
        // opcode = 3'b101;
        // #20; // Espera 1 ciclo completo
        // $display("A = ");
        // display_matrix(A_flat, n);
        // $display("C = ");
        // display_matrix(C_flat, n);

        // Teste 5 - Multiplicação: 011
        $display("\nMultiplicação (opcode 011)");
        opcode = 3'b011;
        #20; // Espera 5 ciclos completos (5 * 20)
        $display("A = ");
        display_matrix(A_flat, n);
        $display("B = ");
        display_matrix(B_flat, n);
        $display("C = ");
        display_matrix(C_flat, n);
        $display("Overflow Flag = %b", overflow_flag);

        // // Teste 7 - Determinante: 111
        // $display("\nTeste 7: Determinante (opcode 111)");
        // opcode = 3'b111;
        // #20; // Espera 1 ciclo completo (assumindo que o determinante é de 1 ciclo)
        // $display("A = ");
        // display_matrix(A_flat, n);
        // $display("C = ");
        // display_matrix(C_flat, n);
        // $display("Overflow Flag = %b", overflow_flag);

        $finish;
    end
endmodule