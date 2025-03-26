module alu_scalar_module (
  input [199:0] A_flat,          // Matriz de entrada achatada (5x5, 200 bits)
  input [7:0] scalar,            // Escalar de 8 bits
  output reg [199:0] C_flat,     // Resultado achatado (5x5, 200 bits)
  output reg overflow_flag,      // Flag de overflow
  output reg done                // Flag de conclusão
);
  integer i;                     // Índice para percorrer os 25 elementos
  reg signed [7:0] a_val;        // Valor temporário de 8 bits
  reg signed [15:0] temp_mult;   // Resultado temporário da multiplicação (16 bits)

  always @(*) begin
    C_flat = 200'b0;             // Inicializa a saída
    overflow_flag = 1'b0;        // Inicializa flag de overflow
    done = 1'b0;                 // Inicializa flag de conclusão

    for (i = 0; i < 25; i = i + 1) begin
      a_val = A_flat[(i*8) +: 8];  // Extrai cada elemento de 8 bits
      temp_mult = a_val * scalar;  // Multiplicação (16 bits)

      // Atribui os 8 bits inferiores ao resultado
      C_flat[(i*8) +: 8] = temp_mult[7:0];

      // Verifica overflow
      if ((temp_mult[15:8] != 8'b00000000 && temp_mult[15] == 0) ||  // Overflow positivo
        (temp_mult[15:8] != 8'b11111111 && temp_mult[15] == 1))    // Overflow negativo
          overflow_flag = 1'b1;
      
    end

    done = 1'b1;  // Operação concluída
    
  end
endmodule