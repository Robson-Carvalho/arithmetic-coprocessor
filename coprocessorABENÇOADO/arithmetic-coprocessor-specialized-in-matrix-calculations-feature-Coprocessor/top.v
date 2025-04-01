module top(
   input [1:0]Key,    // Botão que simula o clock
   input Sw,     // Chave do sinal start
	output LED,
	output LED2,
	input clk
);

	wire WB_signal;
	wire [7:0] mem_address;
	wire [199:0] result_wire;
	wire [199:0] data_wire;
	 
	reg [14:0] instruc;
	reg [1:0] counter;
	reg reset;
	
	// Módulo de memória
	mem_Interface mem(
		.address(mem_address),
		.clk(clk),
		.data_In(result_wire),
		.wren(WB_signal),
		.q(data_wire)
	);
	
	coprocessador(
		.clk(Key[0]),
		.reset(reset),
		.result_wire(result_wire),
		.mem_address(mem_address),
		.WB_wire(WB_signal),
		.Mem_data(data_wire),
		.LED(LED),
		.DONE(LED2)
	);
	 
	 always @(posedge Key[1]) begin
		if(counter == 0)begin 
			counter <= 1;
			reset <= 0;
		end 
		else begin
			counter <= 0;
			reset <= 1;
		end
	 end
	 
endmodule