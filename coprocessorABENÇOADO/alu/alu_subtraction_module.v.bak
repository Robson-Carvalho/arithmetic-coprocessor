module alu_subtraction_module(
  input [199:0] A_flat,
  input [199:0] B_flat,
  output reg [199:0] C_flat,
  output reg overflow_flag,
  output reg done
);
  // Variável para iteração nos 25 elementos
  integer i;                 
  // Soma temporária de 9 bits para detectar overflow
  reg [8:0] temp_sum;        
  // Valor atual de 8 bits extraído de A_flat
  reg signed [7:0] a_val;    
  // Valor atual de 8 bits extraído de B_flat
  reg signed [7:0] b_val;    

  always @(*) begin
    // Zera o vetor de resultado
    C_flat = 200'b0;
    // Zera a flag de overflow
    overflow_flag = 1'b0;
    // Zera a flag de conclusão
    done = 1'b0;          
    
    // Processa os 25 elementos (200 bits / 8 bits = 25)
    for (i = 0; i < 25; i = i + 1) begin
        // Extrai valores de 8 bits dos vetores achatados
        a_val = A_flat[(i*8) +: 8]; // Pega 8 bits a partir da posição i*8
        b_val = B_flat[(i*8) +: 8]; // Pega 8 bits a partir da posição i*8
        
        // Realiza a soma com um bit extra para detectar overflow
        temp_sum = {1'b0, a_val} - {1'b0, b_val};
        
        // Atribui o resultado ao segmento correspondente de 8 bits
        C_flat[(i*8) +: 8] = temp_sum[7:0];
        
        // Verifica overflow:
        // - Se ambos positivos e resultado negativo
        // - Se ambos negativos e resultado positivo
        if ((a_val[7] == 0 && b_val[7] == 0 && temp_sum[7] == 1) ||
            (a_val[7] == 1 && b_val[7] == 1 && temp_sum[7] == 0))
            overflow_flag = 1'b1; // Seta a flag se houver overflow
    end
    
    // Sinaliza que a operação terminou
    done = 1'b1;
  end

endmodule