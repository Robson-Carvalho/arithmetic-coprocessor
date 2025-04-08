module top(
   input [2:0]Key,    // Botão que simula o clock
   input Sw,     // Chave do sinal start
	output LED,
	output LED2,
	output LED9,
	input clk,
	output [5:0] LEDS
);

	wire WB_signal;
	wire [7:0] mem_address;
	wire [15:0] result_wire;
	wire [15:0] data_wire;
	wire start;
	wire start_wire;
	wire clk_25MHz;
	assign start_wire = process;
	 
	reg [1:0] counter;
	reg process;
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
		.clk(clk_25MHz),
		.reset(reset),
		.result_wire(result_wire),
		.Start_process(start),
		.mem_address(mem_address),
		.WB_wire(WB_signal),
		.Mem_data(data_wire),
		.LED(LED),
		.DONE(LED2),
		.overflow(LED9),
		.first_element(LEDS)
	);
	
	debounce dbc(
		.pb_1(Key[0]),
		.clk(clk),
		.pb_out(start)
	);
	
	Clock_divider div (
		.clock_in(clk),
		.clock_out(clk_25MHz)
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

