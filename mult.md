### Módulo de multiplicação

```v
  for (k = 0; k < 5; k = k + 1) begin
    wire signed [7:0] a_val = A_flat[(i*40) + (k*8) +: 8];
    wire signed [7:0] b_val = B_flat[(k*40) + (j*8) +: 8];
    assign prod[k] = bit_mult(a_val, b_val); // OBS: a multplicação acontece aqui.
  end


  assign temp_sum = prod[0] + prod[1] + prod[2] + prod[3] + prod[4]; // soma dos produtos
```

O for acima vai ser convertido em um circuito paralelo. Logo vamos ter:

- `prod[0]` o produto de A11 com B11
- `prod[1]` o produto de A12 com B12
- `prod[2]` o produto de A13 com B13
- `prod[3]` o produto de A14 com B14
- `prod[4]` o produto de A15 com B15

Depois, temos o `temp_sum` que armazena a soma desses produtos e posteriomente armazenamos os 8 bits menos significativos em `C11`.

Repetimos esse processo para cada elemento de `C[ij]`, por isso esse processo ocorre dentro de um dois for aninhado.

```v
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
      if (b[7]) bit_mult = bit_mult - (a << 7);
    end
  endfunction
```

Essa função basicamente implementa o método Shift and Add.
