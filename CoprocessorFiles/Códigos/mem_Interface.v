module mem_Interface(input [7:0]address, input clk, input [15:0]data_In, input wren,
	output [15:00]q);

	Memory mem(
		.address(address),
		.clock(clk),
		.data(data_In),
		.wren(wren),
		.q(q)
	);

endmodule

