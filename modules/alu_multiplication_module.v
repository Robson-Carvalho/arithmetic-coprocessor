module alu_multiplication_module (
    input signed [199:0] A_flat,  
    input signed [199:0] B_flat,  
    output [199:0] C_flat,        
    output overflow_flag          
);

    wire [24:0] overflow;        
    wire signed [15:0] temp [0:24]; 

    genvar i, j, k;
    generate
        for (i = 0; i < 5; i = i + 1) begin : oi
            for (j = 0; j < 5; j = j + 1) begin : oi2
                wire signed [15:0] temp_sum; // somas temporárias
                wire signed [15:0] prod [0:4]; // produtos parciais

                
                for (k = 0; k < 5; k = k + 1) begin : oi3
                    wire signed [7:0] a_val = A_flat[(i*40) + (k*8) +: 8]; 
                    wire signed [7:0] b_val = B_flat[(k*40) + (j*8) +: 8]; 
                    assign prod[k] = bit_mult(a_val, b_val); // OBS: a multplicação acontece aqui.
                end

                
                assign temp_sum = prod[0] + prod[1] + prod[2] + prod[3] + prod[4]; // soma dos produtos
                assign temp[i*5 + j] = temp_sum; // resultado temporário
    
                assign C_flat[(i*40) + (j*8) +: 8] = temp[i*5 + j][7:0]; // Armazena 8 bits de uma vez na posição correta da matriz.
                
                assign overflow[i*5 + j] = (temp[i*5 + j] > 127) || (temp[i*5 + j] < -128); // armazena overflow
            end
        end
    endgenerate

    
    assign overflow_flag = |overflow; // verifica se houve pelo menos 1 overflow e ativa a flag

    
    function signed [15:0] bit_mult;
        input signed [7:0] a, b;
        begin
            bit_mult = 0;
            if (b[0]) bit_mult = bit_mult + a;         
            if (b[1]) bit_mult = bit_mult + (a << 1);  
            if (b[2]) bit_mult = bit_mult + (a << 2);   
            if (b[3]) bit_mult = bit_mult + (a << 3);   
            if (b[4]) bit_mult = bit_mult + (a << 4);   
            if (b[5]) bit_mult = bit_mult + (a << 5);  
            if (b[6]) bit_mult = bit_mult + (a << 6);   
            if (b[7]) bit_mult = bit_mult - (a << 7); // Caso especial para tratar o sinal no 8º bit. 
        end
    endfunction

endmodule