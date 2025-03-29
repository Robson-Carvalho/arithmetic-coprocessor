# Geração do Clock para teste

```v
initial begin
    clock = 0;
    forever begin
        #10 clock = ~clock; // Período de 20 unidades
    end
end
```

**O que isso significa?**

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

## Funcionamento das operações

### Operação Combinacional

```v
$display("\nTeste 6: Produto por escalar (opcode 110)");
opcode = 3'b110;
f = 8'b00000010;
#20; // Espera 1 ciclo completo
$display("A = ");
display_matrix(A_flat, n);
// ...
```

- Tempo 0: `opcode` é definido como `3'b110`, `f` como `8'b00000010`, e o `clock` está em 0 (início da simulação).
- Tempo 10: Primeira borda de subida (`clock = 1`). O `alu` ainda não atualizou as saídas, pois o `opcode` acabou de mudar.
- Tempo 20: Segunda borda de subida não ocorre ainda, mas o atraso `#20` termina aqui. Como `#20` cobre exatamente um ciclo (0 a 20), a borda de subida em 10 já atualizou as saídas no `alu`. Então, `C_flat` reflete o resultado do produto por escalar (cada elemento de `A_flat` multiplicado por 2).

### Operação Síncrona

```v
$display("\nTeste 5: Multiplicação (opcode 011)");
opcode = 3'b011;
#100; // Espera 5 ciclos completos (5 * 20)
$display("A = ");
display_matrix(A_flat, n);
// ...
```

- **Tempo X:** `opcode` muda para `3'b011` (o tempo exato depende de quando o teste anterior terminou, mas vamos assumir que começa em 0 para simplificar).
- **Tempo 10:** Primeira borda de subida. O `alu` passa o controle ao `alu_multiplication_module`, que começa a calcular a primeira linha de `C_flat`.
- **Tempo 30:** Segunda borda de subida. Segunda linha calculada.
- **Tempo 50:** Terceira borda de subida. Terceira linha calculada.
- **Tempo 70:** Quarta borda de subida. Quarta linha calculada.
- **Tempo 90:** Quinta borda de subida. Quinta linha calculada, e `done` é setado para 1 no `alu_multiplication_module`.
- **Tempo 100:** O atraso `#100` termina. As 5 bordas de subida (10, 30, 50, 70, 90) já ocorreram, e `C_flat` contém o resultado completo da multiplicação.

O módulo `alu_multiplication_module` processa uma linha por ciclo, então 5 ciclos (100 unidades de tempo) são suficientes para completar a matriz 5x5.

## Sincronização

O atraso `#20` ou `#100` alinha as leituras do testbench com as atualizações síncronas do alu. Sem esses atrasos (ou com atrasos insuficientes, como #1), você leria as saídas antes da borda de subida, resultando em valores indefinidos ("x").
