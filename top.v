module top (
    input clk,
    input reset_n,
    
    // AXI4-Lite Interface
    input [31:0] axi_awaddr,
    input axi_awvalid,
    output axi_awready,
    
    input [31:0] axi_wdata,
    input axi_wvalid,
    output axi_wready,
    
    output axi_bvalid,
    input axi_bready,
    
    input [31:0] axi_araddr,
    input axi_arvalid,
    output axi_arready,
    
    output [31:0] axi_rdata,
    output axi_rvalid,
    input axi_rready
);

    wire [31:0] num1;
    wire [31:0] num2;
    wire [1:0] instruction;
    wire [31:0] result;
    wire ready;

    axi_slave axi_slave_inst (
        .clk(clk),
        .reset_n(reset_n),
        .axi_awaddr(axi_awaddr),
        .axi_awvalid(axi_awvalid),
        .axi_awready(axi_awready),
        .axi_wdata(axi_wdata),
        .axi_wvalid(axi_wvalid),
        .axi_wready(axi_wready),
        .axi_bvalid(axi_bvalid),
        .axi_bready(axi_bready),
        .axi_araddr(axi_araddr),
        .axi_arvalid(axi_arvalid),
        .axi_arready(axi_arready),
        .axi_rdata(axi_rdata),
        .axi_rvalid(axi_rvalid),
        .axi_rready(axi_rready),
        .num1(num1),
        .num2(num2),
        .instruction(instruction),
        .result(result),
        .ready(ready)
    );

    coprocessor coprocessor_inst (
        .clk(clk),
        .reset_n(reset_n),
        .num1(num1),
        .num2(num2),
        .instruction(instruction),
        .result(result),
        .ready(ready)
    );

endmodule
