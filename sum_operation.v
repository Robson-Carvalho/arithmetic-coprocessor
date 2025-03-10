module sum_operation(
	input wire [31:0] A,
	input wire [31:0] B,
	output [31:0] C
);
 
	
	assign C[7:0] = A[7:0] + B[7:0];
	assign C[15:8] = A[15:8] + B[15:8];
	assign C[23:16] = A[23:16] + B[23:16];
	assign C[31:24] = A[31:24] + B[31:24];
	
endmodule 