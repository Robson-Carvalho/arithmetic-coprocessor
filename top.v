module top(
   input [1:0]Key,    // Botão que simula o clock
   input Sw,     // Chave do sinal start
	output LED,
	input clk,
	input reset
);

	wire WB_signal;
	wire [7:0] mem_address;
	wire [199:0] result_wire;
	wire [199:0] data_wire;
	 
	reg [14:0] instruc;
	reg [4:0] counter;
	
	and(clk_start, Key[0], Sw);
	
	// Módulo de memória
	mem_Interface mem(
		.address(mem_address),
		.clk(clk),
		.data_In(result_wire),
		.wren(WB_signal),
		.q(data_wire)
	);
	
	coprocessador(
		.clk(clk_start),
		.reset(reset),
		.result(result_wire),
		.mem_address(mem_address),
		.WB(WB_signal),
		.Mem_data(data_wire)
	);
	 
	 
	 
endmodule
