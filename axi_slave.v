module axi_slave (
    input clk,
    input reset_n,
    
    // AXI4-Lite Interface
    input [31:0] axi_awaddr,
    input axi_awvalid,
    output reg axi_awready,
    
    input [31:0] axi_wdata,
    input axi_wvalid,
    output reg axi_wready,
    
    output reg axi_bvalid,
    input axi_bready,
    
    input [31:0] axi_araddr,
    input axi_arvalid,
    output reg axi_arready,
    
    output reg [31:0] axi_rdata,
    output reg axi_rvalid,
    input axi_rready,
    
    // Interface para o coprocessador
    output reg [31:0] num1,
    output reg [31:0] num2,
    output reg [1:0] instruction,
    input [31:0] result,
    input ready
);

    // Lógica para lidar com as transações AXI
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            axi_awready <= 1'b0;
            axi_wready <= 1'b0;
            axi_bvalid <= 1'b0;
            axi_arready <= 1'b0;
            axi_rvalid <= 1'b0;
            num1 <= 32'b0;
            num2 <= 32'b0;
            instruction <= 2'b0;
        end else begin
            // Lógica para escrita (AW, W, B channels)
            if (axi_awvalid && !axi_awready) begin
                axi_awready <= 1'b1;
            end else begin
                axi_awready <= 1'b0;
            end

            if (axi_wvalid && !axi_wready) begin
                axi_wready <= 1'b1;
                case (axi_awaddr)
                    32'h0000: num1 <= axi_wdata;
                    32'h0004: num2 <= axi_wdata;
                    32'h0008: instruction <= axi_wdata[1:0];
                endcase
            end else begin
                axi_wready <= 1'b0;
            end

            if (axi_wready && axi_awready) begin
                axi_bvalid <= 1'b1;
            end else if (axi_bready) begin
                axi_bvalid <= 1'b0;
            end

            // Lógica para leitura (AR, R channels)
            if (axi_arvalid && !axi_arready) begin
                axi_arready <= 1'b1;
            end else begin
                axi_arready <= 1'b0;
            end

            if (axi_arready) begin
                case (axi_araddr)
                    32'h000C: axi_rdata <= result;
                    32'h0010: axi_rdata <= {31'b0, ready};
                endcase
                axi_rvalid <= 1'b1;
            end else if (axi_rready) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

endmodule