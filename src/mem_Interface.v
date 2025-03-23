module mem_Interface(input [7:0]address, input clk, input [255:0]data_In, input wren,
	output [255:00]q
);

	Memory mem(
		.address(address),
		.clock(clk),
		.data(data_In),
		.wren(wren),
		.q(q)
	);



endmodule
