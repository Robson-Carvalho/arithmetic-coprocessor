module alu_determinant_module(
  input [199:0] A_flat,          // Matriz A achatada (5x5, 200 bits)
  output reg [199:0] C_flat,     // Resultado (determinante nos 8 bits menos significativos)
  output reg overflow_flag,      // Flag de overflow
  output reg done                // Flag de finalização
);
  integer i, j, k;               // Índices para loops
  reg signed [7:0] matrix [0:4][0:4]; // Matriz 5x5 para manipulação
  reg signed [15:0] temp;        // Registrador temporário para cálculos
  reg signed [31:0] det;         // Acumulador do determinante (32 bits para evitar overflow intermediário)
  reg zero_pivot;                // Flag para indicar pivô zero

  always @(*) begin
    // Inicializa saídas
    C_flat = 200'b0;
    overflow_flag = 1'b0;
    done = 1'b0;
    det = 32'b1;                 // Inicializa determinante como 1
    zero_pivot = 1'b0;           // Inicializa flag de pivô zero como falso

    // Preenche a matriz a partir de A_flat
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5; j = j + 1) begin
        matrix[i][j] = A_flat[(i*5 + j)*8 +: 8];
      end
    end

    // Eliminação de Gauss
    for (k = 0; k < 4; k = k + 1) begin // Até a penúltima coluna (k < n-1)
      if (matrix[k][k] == 0) begin
        // Se o pivô é zero, marca a flag e não continua a eliminação
        zero_pivot = 1'b1;
      end
      else begin
        // Elimina elementos abaixo do pivô
        for (i = k + 1; i < 5; i = i + 1) begin
          temp = (matrix[i][k] << 8) / matrix[k][k]; // Escala para evitar divisão direta
          for (j = k; j < 5; j = j + 1) begin
            matrix[i][j] = matrix[i][j] - ((temp * matrix[k][j]) >> 8);
            // Verifica overflow em cada operação
            if ((matrix[i][j][7] == 0 && (matrix[i][j] > 127)) || 
                (matrix[i][j][7] == 1 && (matrix[i][j] < -128)))
              overflow_flag = 1'b1;
          end
        end
      end
    end

    // Calcula o determinante como o produto dos elementos da diagonal
    if (zero_pivot) begin
      det = 32'b0;  // Determinante é zero se houve pivô zero
      C_flat[7:0] = 8'b0;
    end
    else begin
      det = 32'b1;
      for (i = 0; i < 5; i = i + 1) begin
        temp = det * matrix[i][i];
        det = temp;
        // Verifica overflow no produto
        if ((temp[31:8] != 24'b0 && temp[31] == 0) || 
            (temp[31:8] != 24'b111111111111111111111111 && temp[31] == 1))
          overflow_flag = 1'b1;
      end
      // Atribui o determinante aos 8 bits menos significativos de C_flat
      C_flat[7:0] = det[7:0];
      if ((det[31:8] != 24'b0 && det[31] == 0) || 
          (det[31:8] != 24'b111111111111111111111111 && det[31] == 1))
        overflow_flag = 1'b1;
    end

    // Sinaliza conclusão
    done = 1'b1;
  end
endmodule