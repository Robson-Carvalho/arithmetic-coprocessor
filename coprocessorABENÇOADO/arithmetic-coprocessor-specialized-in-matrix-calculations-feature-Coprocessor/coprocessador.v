	module coprocessador(
    input clk, reset,
	 input [199:0] Mem_data,
	 output reg LED,
	 output [199:0]result_wire,
	 output [7:0]mem_address,
	 output WB_wire,
	 output DONE
);
    
     // Estados do processador
    parameter FETCH = 3'b000;
    parameter DECODE = 3'b001;
    parameter EXECUTE = 3'b010;
	 parameter WRITEBACK = 3'b011;
	 parameter CLEANUP = 3'b100;

    reg [2:0] state_reg, state_next;

    // Campos da instrução
    reg [2:0] opcode;
    reg [2:0] matrix_size;
    reg [199:0] matrix1, matrix2;
	 reg [7:0] real_number;
	 reg [7:0] address;
	 reg [14:0]instructionReg;
	 reg [199:0] result;
	 reg WB;

    // Fios de saída dos módulos
    wire [199:0] ula_result;
	 assign WB_wire = WB;
	 assign result_wire = result;
	 assign mem_address = address;
	 
	 //Flags
	 reg Flag_A;
    
    // Unidade Lógica Aritmética (ULA)
	 alu ALU(
	 .A_flat(matrix1),
	 .B_flat(matrix2),
	 .f(real_number),
	 .opcode(opcode),
	 .C_flat(ula_result),
	 .done(DONE)
	 );

    // Lógica de transição de estados
    always @(posedge clk or posedge reset) begin
		 if (reset)
			  state_reg <= FETCH;
		 else
			  state_reg <= state_next;  // Estado avança corretamente
	end
	
	// Lógica combinacional para o próximo estado
		always @(*) begin
			 case (state_reg)
				  FETCH: state_next = DECODE;
				  DECODE: state_next = EXECUTE;
				  EXECUTE: state_next = WRITEBACK;
				  WRITEBACK: state_next = CLEANUP;
				  CLEANUP: state_next = FETCH;
				  default: state_next = FETCH;
			 endcase
		end

    // Lógica do pipeline
    always @(posedge clk or posedge reset) begin
			if (reset) begin
			  instructionReg <= 15'b0;  
			  opcode <= 3'b0;           
			  matrix_size <= 3'b0;
			  matrix1 <= 200'b0;
			  matrix2 <= 200'b0;
			  Flag_A <= 1'b0;                   
			  WB <= 1'b0;               
			  result <= 200'b0;         
			end else begin
				  case (state_reg)
						FETCH: begin
							 address <= 8'b00000000;
							 instructionReg <= Mem_data;
							 LED <= 1'b1;
						end
						
						DECODE: begin
							 opcode <= instructionReg[0 +: 3];
							 matrix_size <= instructionReg[3 +: 3];
							 address <= 8'b00000001;
							 Flag_A <= instructionReg[14 +: 1];
							 LED <= 1'b0;
						end

						EXECUTE: begin
							 case (opcode)
								  3'b000: begin                   //Load
										if(Flag_A == 0) begin			
											matrix1 = Mem_data;
											LED <= 1'b0;
										end
										else begin
											matrix2 = Mem_data;
											LED <= 1'b0;
										end
								  end
								  3'b001: begin                   
										result <= ula_result;
										address <= 8'b00000011;
										LED <= 1'b1;
								  end
								  
								  3'b010: begin              
										address <= 8'b00000011;
										result <= ula_result;
										LED <= 1'b1;
								  end
								  
								  3'b011: begin    
										address <= 8'b00000011;
										result <= ula_result;
										LED <= 1'b1;
								  end
								  
								  3'b100: begin    
										address <= 8'b00000011;
										result <= ula_result;
										LED <= 1'b1;
								  end
								  
								  3'b101: begin                 
										address <= 8'b00000011;
										result <= ula_result;
										real_number <= matrix2[0 +: 8]; 
										LED <= 1'b1;
								  end
								  
								  3'b110: begin                  
										address <= 8'b00000011;
										result <= ula_result;
										LED <= 1'b1;
								  end
								  
								  3'b111: begin 
										address <= 8'b00000011;
										result <= ula_result;
										LED <= 1'b1;
								  end
							 endcase
						end
				WRITEBACK: begin
					address <= 8'b00000011;
					WB <= 1'b1;
					LED <= 1'b1;
				end
				
				CLEANUP: begin
					instructionReg <= 15'b000000000000000;
					opcode <= 3'b000;
					matrix_size <= 3'b000;
					Flag_A <= 1'b0;
					WB <= 1'b0;
					result <= 200'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
					LED <= 1'b0;
					address <= 8'b00000000;
				end
				endcase
		  end
    end
	 
	 // Adicionando sinais de depuração
    always @(posedge clk) begin
        // Depuração para verificar se o estado está mudando corretamente
        $display("State Reg: %b, State Next: %b", state_reg, state_next);
    end

endmodule