	module coprocessador(
    input clk, reset,
	 input [15:0] Mem_data,
	 input Start_process,
	 output reg LED,
	 output [15:0]result_wire,
	 output [7:0]mem_address,
	 output WB_wire,
	 output DONE,
	 output overflow,
	 output [5:0] first_element
);
    
     // Estados do processador
    parameter FETCH = 3'b000;
    parameter DECODE = 3'b001;
    parameter EXECUTE = 3'b010;
	parameter WRITEBACK = 3'b011;
	parameter CLEANUP = 3'b100;

    reg [2:0] state_reg, state_next;

   // =======REGISTRADORES DE CONTROLE
    reg [2:0] opcode;
    reg [2:0] matrix_size;
    reg [199:0] matrix1, matrix2;
	reg [7:0] real_number;
	reg [7:0] address;
	reg [6:0]instructionReg;
	reg [199:0] result;
	reg WB;
	reg loadingMatrix;
	reg [4:0] load_counter;
	reg [7:0] base_address;
	reg [15:0] write_data;
	reg [4:0] store_counter;
	reg [2:0] write_counter;
	reg [5:0] det_counter;
	reg write_done;
	reg load_done;
	reg [2:0] row1, row2;
	reg [2:0] col1, col2;
	reg [4:0] virt_idx1, virt_idx2;
	reg read_pending;
	reg fetch_done;
	reg fetch_pending;
	reg det_done;

    // Fios de saída dos módulos
    wire [199:0] ula_result;
	 wire [2:0] size_wire;
	 assign WB_wire = WB;
	 assign mem_address = address;
	 assign result_wire = write_data;
	 assign first_element = matrix1[16:8];
	 assign size_wire = matrix_size;
	 
	 //Flags
	 reg Flag_A;
    
    // Unidade Lógica Aritmética (ULA)
	 alu ALU(
	 .A_flat(matrix1),
	 .B_flat(matrix2),
	 .scalar(real_number),
	 .opcode(opcode),
	 .clock(clk),
	 .C_flat(ula_result),
	 .overflow_flag(overflow),
	 .matrix_size(size_wire)
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
				FETCH: state_next = (Start_process) ? DECODE : FETCH; // ===OBS=== Falta colocar uma flag de start
				DECODE: state_next = EXECUTE;
			   EXECUTE: begin
					 if (opcode == 3'b000 && load_done == 1) begin
						  state_next = CLEANUP;  // Se opcode for 3'b000 e load_done for 1, vai para CLEANUP
					 end else if (opcode == 3'b000 && load_done == 0) begin
						  state_next = EXECUTE;  // Se opcode for 3'b000 e load_done for 0, permanece em EXECUTE
					 end  else if (opcode == 3'b111 && det_done == 0)begin
							state_next = EXECUTE;
					 end else begin
						  state_next = WRITEBACK;  // Para qualquer outro caso, vai para WRITEBACK
					 end
				end
			    WRITEBACK: state_next = (write_done) ? CLEANUP : WRITEBACK;
				CLEANUP: state_next = FETCH;
				default: state_next = FETCH;
			 endcase
		end

    // Lógica do pipeline
    always @(posedge clk or posedge reset) begin
			if (reset) begin
			  instructionReg <= 7'b0;  
			  opcode <= 3'b0;           
			  matrix_size <= 3'b0;
			  Flag_A <= 1'b0;                   
			  WB <= 1'b0;               
			  result <= 200'b0; 
			  loadingMatrix <= 0;
			  load_counter <= 0;
			  base_address <= 0;
			  write_done <= 1'b0;
			  load_done <= 0;
			  store_counter <= 0;
			  write_counter <= 0;
			  address <= 0;
			  fetch_done <=0;
			  fetch_pending <=0;
			  det_done <= 0;
			end else begin
				  case (state_reg)
						FETCH: begin
								address <= 8'b0;
								LED <= 1'b1;
								fetch_pending <= 1;	
								instructionReg <= Mem_data[6:0];
						end
						
						DECODE: begin
							 opcode <= instructionReg[0 +: 3];
							 matrix_size <= instructionReg[3 +: 3];
							 address <= 8'b00000001;
							 Flag_A <= instructionReg[6 +: 1];
							 LED <= 1'b0;
							 $display("DECODE: opcode=%b, matrix_size=%d, Flag_A=%b", instructionReg[2:0], instructionReg[5:3], instructionReg[6]);
						end

						EXECUTE: begin
								case (opcode)
									// ======= LOAD MATRIZ ==========
									3'b000: begin
									if (!loadingMatrix) begin
										loadingMatrix <= 1;
										load_counter <= 0;
										base_address <= address;
										read_pending <= 1;
										if (Flag_A == 0) matrix1 <= 200'b0;
										else matrix2 <= 200'b0;
									end else if (read_pending) begin
										read_pending <= 0; // Espera 1 ciclo para Mem_data
									end else begin
										read_pending <= 1;
										if (load_counter < (matrix_size * matrix_size)) begin
											row1 = load_counter / matrix_size;
											col1 = load_counter % matrix_size;
											virt_idx1 = row1 * 5 + col1;
											if (Flag_A == 0) begin
												matrix1[virt_idx1*8 +: 8] <= Mem_data[15:8];
											end else begin
												matrix2[virt_idx1*8 +: 8] <= Mem_data[15:8];
											end
										end
										if ((load_counter + 1) < (matrix_size * matrix_size)) begin
											row2 = (load_counter + 1) / matrix_size;
											col2 = (load_counter + 1) % matrix_size;
											virt_idx2 = row2 * 5 + col2;
											if (Flag_A == 0) begin
												matrix1[virt_idx2*8 +: 8] <= Mem_data[7:0];
											end else begin
												matrix2[virt_idx2*8 +: 8] <= Mem_data[7:0];
											end
										end
										load_counter <= load_counter + 2;
										if ((load_counter + 2) >= (matrix_size * matrix_size)) begin
											load_done <= 1;
										end else begin
											address <= address + 1;
										end
									end
								end
							  // ======= OPERAÇÕES (ex: soma, sub, etc) ==========
							  3'b001, 3'b010, 3'b011, 3'b100, 3'b110: begin
									result <= ula_result;
									address <= 8'b00000011; // Endereço de gravação (ajuste se quiser)
									LED <= 1'b1;
							  end

							  // ======= ESCALAR ==========
							  3'b101: begin
									result <= ula_result;
									real_number <= matrix2[0 +: 8]; // Pega escalar da matrix2 (ou outro campo)
									address <= 8'b00000011;
									LED <= 1'b1;
							  end
							  
							  3'b111: begin
									det_done <= 0;
									result <= ula_result;
									address <= 8'b00000011; // Endereço de gravação (ajuste se quiser)
									LED <= 1'b1;
									if(det_counter < 3) begin
										det_counter = det_counter + 1;
									end else begin
										det_done <= 1;
									end
							  end
						 endcase
					end
					
						WRITEBACK: begin
							 LED <= 1'b1;
							 WB <= 1'b1;

							 // Sempre lê do buffer 5x5 (25 elementos)
							 write_data[15:8] <= result[store_counter*8 +: 8];  // Elemento atual
							 write_data[7:0] <= result[(store_counter+1)*8 +: 8]; // Próximo elemento

							 // Endereço base + offset (cada par ocupa 1 half-word)
							 address <= 8'd14 + (store_counter >> 1);

							 // Controle de ciclos de escrita
							 if (write_counter < 3) begin
								  write_counter <= write_counter + 1;
							 end else begin
								  write_counter <= 0;
								  store_counter <= store_counter + 2;

								  // Finaliza após escrever TODOS os 25 elementos (5x5)
								  if (store_counter >= 24) begin  // 25º elemento está no índice 24
										WB <= 0;
										store_counter <= 0;
										write_done <= 1'b1;
								  end
							 end
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
					loadingMatrix <= 0;
			      load_counter <= 0;
			       base_address <= 0;
					 write_done <= 1'b0;
					 load_done <= 0;
					 store_counter <= 0;
					 write_counter <= 0;
					 write_data <= 16'b0;
					 fetch_done <=0;
					read_pending <=0;
					fetch_pending <=0;
					det_done <= 0;
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
