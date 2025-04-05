module alu_subtraction_module(
  input [199:0] A_flat,
  input [199:0] B_flat,
  output [199:0] C_flat,
  output overflow_flag
);
  wire [24:0] overflow;  // Sinal de overflow para cada elemento

  genvar i;
  generate
    for (i = 0; i < 25; i = i + 1) begin : process_elements
      // Declarações locais para cada iteração
      wire signed [7:0] a_val = A_flat[(i*8) +: 8];
      wire signed [7:0] b_val = B_flat[(i*8) +: 8];
      wire [8:0] temp_sub = {1'b0, a_val} - {1'b0, b_val};
      
      // Saída do resultado
      assign C_flat[(i*8) +: 8] = temp_sub[7:0];
      
      // Detecção correta de overflow para subtração signed
      assign overflow[i] = (a_val[7] != b_val[7]) && (temp_sub[7] != a_val[7]);
    end
  endgenerate
    
  assign overflow_flag = |overflow;
endmodule