	module coprocessador(
    input clk, reset,
	 input [199:00] Mem_data,
	 output reg [199:0]result,
	 output reg [7:0]mem_address,
	 output reg WB
);
    
    // Estados do processador
    parameter FETCH = 2'b00;
    parameter DECODE = 2'b01;
    parameter EXECUTE = 2'b10;

    reg [1:0] state_reg, state_next;

    // Campos da instrução
    reg [2:0] opcode;
    reg [2:0] matrix_size;
    reg [199:0] matrix1, matrix2;
	 reg [8:0] real_number;
	 reg [7:0] address;
	 reg [14:0]instructionReg;

    // Fios de saída dos módulos
    wire [199:0] ula_result;
	 
	 //Flags
	 reg Flag_A;
    
    // Unidade Lógica Aritmética (ULA)
	 malu ALU(
	 .A_flat(matrix1),
	 .B_flat(matrix2),
	 .n(matrix_size),
	 .f(real_number),
	 .opcode(opcode),
	 .C_flat(ula_result)
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
				  EXECUTE: state_next = FETCH;
				  default: state_next = FETCH;
			 endcase
		end

    // Lógica do pipeline
    always @(posedge clk or posedge reset) begin
			if (reset) begin
			  instructionReg <= 15'b0;  
			  opcode <= 3'b0;           
			  matrix_size <= 3'b0;              
			  Flag_A <= 1'b0;           
			  matrix1 <= 200'b0;        
			  matrix2 <= 200'b0;        
			  WB <= 1'b0;               
			  result <= 200'b0;         
			end else begin
				  case (state_reg)
						FETCH: begin
							 mem_address = 8'b00000000;
							 instructionReg = Mem_data;
							 WB = 1'b0;
						end
						
						DECODE: begin
							 opcode = instructionReg[0 +: 3];
							 matrix_size = instructionReg[3 +: 3];
							 mem_address = instructionReg[6 +: 8];
							 Flag_A = instructionReg[14 +: 1];
						end

						EXECUTE: begin
							 case (opcode)
								  3'b000: begin                   //Load
										if(Flag_A == 0) begin
											matrix1 = Mem_data;
										end
										else begin
											matrix2 = Mem_data;
										end
								  end
								  3'b001: begin                   
										result = ula_result;
										WB = 1'b1;
								  end
								  
								  3'b010: begin                  
										result = ula_result;
										WB = 1'b1;
								  end
								  
								  3'b011: begin                 
										result = ula_result;
										WB = 1'b1;
								  end
								  
								  3'b100: begin                 
										result = ula_result;
										WB = 1'b1;
								  end
								  
								  3'b101: begin                 
										result = ula_result;
										real_number = matrix2[0 +: 8]; 
										WB = 1'b1;
								  end
								  
								  3'b110: begin                  
										result = ula_result;
										WB = 1'b1;
								  end
								  
								  3'b111: begin                  
										result = ula_result;
										WB = 1'b1;
								  end

							 endcase
						end

				endcase
		  end
    end

endmodule
