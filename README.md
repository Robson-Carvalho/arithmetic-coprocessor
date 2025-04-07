# 🧮 Unidade Lógica-Aritmética (ULA) Matricial

## 📌 Visão Geral

Este projeto implementa uma **Unidade Lógico-Aritmética (ALU)** especializada em operações com matrizes de até 5×5 elementos (8 bits com sinal). Desenvolvido em Verilog e testado com Icarus Verilog.

## 🏗️ Arquitetura

### Módulo Principal (`alu.v`)

- Controla todas as operações
- Seleciona sub-módulos baseado no opcode
- Gerencia sinais de clock, done e overflow

### Sub-módulos Especializados

| Módulo                      | Operação | Descrição                     |
| --------------------------- | -------- | ----------------------------- |
| `alu_sum_module`            | A + B    | Soma elemento a elemento      |
| `alu_subtraction_module`    | A - B    | Subtração elemento a elemento |
| `alu_multiplication_module` | A × B    | Multiplicação matricial       |
| `alu_opposite_module`       | -A       | Matriz oposta                 |
| `alu_transpose_module`      | Aᵀ       | Matriz transposta             |
| `alu_scalar_module`         | k·A      | Multiplicação por escalar     |
| `alu_determinant_module`    | det(A)   | Cálculo de determinante       |

## 📊 Operações Suportadas

```verilog
case (opcode)
  3'b001: begin  // Soma
      C_flat = sum_C;
      overflow_flag = sum_ovf;
  end
  3'b010: begin  // Subtração
      C_flat = sub_C;
      overflow_flag = sub_ovf;
  end
  3'b011: begin  // Multiplicação
      C_flat <= mul_C;
      overflow_flag <= mul_ovf;
  end
  3'b100: begin  // Matriz oposta
      C_flat = opposite_C;
  end
  3'b101: begin  // Transposta
      C_flat = transpose_C;
  end
  3'b110: begin  // Produto por escalar
      C_flat = scalar_C;
      overflow_flag = scalar_ovf;
  end
  3'b111: begin  // Determinante
      number = determinant_number;
      overflow_flag = determinant_ovf;
      done = determinant_done;
  end
  default: begin // Caso inválido
      C_flat = 200'b0;
      overflow_flag = 1'b0;
      done = 1'b1;
  end
endcase
```

## 🔍 Detecção de Overflow

- Soma/Subtração: Verifica mudança inesperada no bit de sinal

- Multiplicação: Checa se bits superiores diferem do bit de sinal

- Determinante: Verifica se resultado excede 8 bits

## ⚙️ Como Executar

1. Executar makefile:

```bash
make run
```

## Simulando Clock Rate

```v
initial begin
    clock = 0;
    forever begin
        #10 clock = ~clock; // Período de 20 unidades
    end
end
```

- `initial begin:` Este bloco é executado uma única vez no início da simulação.
- `clock = 0:` O clock começa em nível baixo (0).
- `forever begin:` Um loop infinito que continua rodando durante toda a simulação.
- `#10 clock = ~clock:` A cada 10 unidades de tempo de simulação, o valor do clock é invertido (de 0 para 1 ou de 1 para 0).

### Temporização do Clock

O clock alterna entre 0 e 1 a cada 10 unidades de tempo. Um ciclo completo do clock (de 0 para 1 e de volta para 0) leva 20 unidades de tempo:

- 0 a 10: clock = 0 → clock = 1 (borda de subida).
- 10 a 20: clock = 1 → clock = 0 (borda de descida).

Isso define o período do clock como 20 unidades de tempo.

### Forma de Onda do Clock

Se visualizarmos o clock ao longo do tempo:

```txt
Tempo:    0    10   20   30   40   50   60   70   80   90  100
Clock:    0     1    0    1    0    1    0    1    0    1    0
          |borda|    |borda|    |borda|    |borda|    |borda|
          subida     subida     subida     subida     subida
```

## Sincronização

O atraso `#20` ou `#100` alinha as leituras do testbench com as atualizações síncronas do alu. Sem esses atrasos (ou com atrasos insuficientes, como #1), você leria as saídas antes da borda de subida, resultando em valores indefinidos ("x").

## 📌 Principais Características

- ✅ Suporte a matrizes 2×2 até 5×5

- ✅ Detecção automática de overflow

- ✅ Operações combinacionais e sequenciais

- ✅ Testes abrangentes para todos os casos
