# Relatório Técnico - Coprocessador Aritmético em FPGA

## Sumário

- [Objetivos e Requisitos do Problema](#objetivos-e-requisitos-do-problema)
- [Recursos Utilizados](#recursos-utilizados)
  - [Quartus Prime](#quartus-prime)
  - [FPGA DE1-SoC](#fpga-de1-soc)
  - [Icarus Verilog](#icarus-verilog)
- [Desenvolvimento e Descrição em Alto Nível](#desenvolvimento-e-descrição-em-alto-nível)
  - [Unidade de Controle](#unidade-de-controle)
  - [ULA (Unidade Lógica e Aritmética)](#ula-unidade-lógica-e-aritmética)
- [Testes, Simulações, Resultados e Discussões](#testes-simulações-resultados-e-discussões)

---

## Introdução

Coprocessadores são componentes de hardware que atuam em conjunto com a CPU (Central Processing Unit), oferecendo suporte a tarefas específicas, geralmente com foco em otimização e desempenho. No contexto deste trabalho, foi desenvolvido um **coprocessador aritmético voltado para operações matriciais**, com o objetivo de acelerar cálculos complexos que seriam custosos se executados apenas pela CPU principal.

Esse projeto visa explorar os recursos da FPGA **DE1-SoC**, utilizando **descrição em Verilog** para projetar um sistema digital capaz de realizar operações fundamentais no processamento de matrizes. A escolha de implementar esse tipo de operação está relacionada à ampla aplicação em áreas como processamento de imagem, álgebra linear, simulações numéricas, aprendizado de máquina, entre outras.

## Objetivos e Requisitos do Problema

O coprocessador foi planejado com foco em **desempenho**, utilizando **paralelismo em nível de hardware** para otimizar o tempo de execução das operações. Além disso, a compatibilidade com os dispositivos da DE1-SoC garante a viabilidade prática do projeto no ambiente de desenvolvimento utilizado.

### Requisitos do Projeto

1. Descrição completa do hardware utilizando a linguagem **Verilog**.  
2. O sistema deve ser compatível e utilizar os componentes disponíveis na **FPGA DE1-SoC**.  
3. Capacidade de realizar as seguintes operações matriciais:
   - Soma  
   - Subtração  
   - Multiplicação de matrizes  
   - Multiplicação por número inteiro  
   - Cálculo do determinante  
   - Transposição  
   - Geração da matriz oposta  
4. Cada elemento da matriz é representado por um número de **8 bits (1 byte)**.  
5. O processador deve implementar **paralelismo** para otimizar operações aritméticas.

- Quais os requisitos funcionais e não funcionais.
- Restrições ou limitações do projeto.

## Recursos Utilizados

### Quartus Prime
Explicar como o Quartus Prime foi utilizado no desenvolvimento, como a criação do projeto, síntese, análise de tempo e gravação na FPGA.

### FPGA DE1-SoC
Descrever as características da placa utilizada, como número de portas, switches, LEDs, e como ela foi utilizada no projeto.

### Icarus Verilog
Comentar sobre o uso das ferramenta para simulação:
- Escrita e testes dos módulos em Verilog.

## Desenvolvimento e Descrição em Alto Nível

### Unidade de Controle

A **unidade de controle** é o componente responsável por processar as instruções, gerenciar o fluxo de dados e coordenar os outros componentes internos, funcionando como um organizador geral do sistema. Sua função é crucial para garantir a execução eficiente das operações, especialmente no contexto de processamentos matriciais.

A unidade de controle gerencia a comunicação entre a **memória RAM**, que armazena as matrizes a serem manipuladas, e os demais componentes, como a **ULA (Unidade Lógica e Aritmética)**, responsável pelo processamento aritmético das matrizes. Ela também desempenha um papel fundamental na **sincronização geral do sistema**, garantindo que todas as operações ocorram no tempo correto e de maneira ordenada.

Em termos de desempenho, a unidade de controle é o "cérebro" do sistema, sendo responsável por organizar e orquestrar as etapas de cada operação matricial. Ela garante que os dados sejam lidos da memória na ordem correta, que as operações sejam executadas corretamente pela ULA e que o fluxo de controle seja mantido sem erros durante o processamento das matrizes.

### Instruction Set Architecture
As instruções desenvolvidas para o coprocessador seguem um padrão uniforme para todos os tipos de operações realizadas, sejam elas de transferência de dados ou operações aritméticas. Essa decisão de projeto foi tomada com o objetivo de simplificar a complexidade associada à implementação das instruções, assegurando que a etapa de decodificação fosse generalizada e simplificada.
As instruções possuem um tamanho fixo de 8 bits e a estrutura das instruções é organizada da seguinte forma:

![Formato da instrução](https://br.pinterest.com/pin/725924033725138267)
Os campos da instruçã são definidos por:
| Atributo | Descrição |
|----------|-----------|
| **MT**   | Matriz alvo do carregamento (A ou B) |
| **M_Size** | Tamanho da matriz utilizado por operações de movimentação de dados e aritméticas |
| **OPCODE** | Código de operação |

Conjunto de instruções do coprocessador:
### Instruções aritméticas e seus Códigos Hexadecimais

| Instrução       | Código Hexadecimal |
|-----------------|--------------------|
| **Soma**        | `0x01`             |
| **Subtração**   | `0x02`             |
| **Multiplicação**| `0x03`            |
| **Multiplicação por número inteiro** | `0x04` |
| **Transposição** | `0x05`             |
| **Matriz Oposta**| `0x06`            |
| **Determinante 2x2** | `0x17`             |
| **Determinante 3x3** | `0x1F`             |
| **Determinante 4x4** | `0x27`             |
| **Determinante 5x5** | `0x2F`             |

### Instruções de movimentação de dados e seus Códigos Hexadecimais

| Instrução       | Código Hexadecimal |
|-----------------|--------------------|
| **Carregar matriz A 2x2** | `0x10`             |
| **Carregar matriz A 3x3** | `0x18`             |
| **Carregar matriz A 4x4** | `0x20`             |
| **Carregar matriz A 5x5** | `0x28`             |
| **Carregar matriz B 2x2** | `0x50`             |
| **Carregar matriz B 3x3** | `0x58`             |
| **Carregar matriz B 4x4** | `0x60`             |
| **Carregar matriz B 5x5** | `0x68`             |

### Etapas de processamento

### Fluxos de execução

### Banco de Registradores

## Módulo de memória

### Leitura e escrita dos dados a partir da memória

### Sincronização

### ULA (Unidade Lógica e Aritmética)
- Operações suportadas.
- Como a ULA recebe os sinais de controle.
- Como os resultados são manipulados e enviados.

## Testes, Simulações, Resultados e Discussões

- Descrever os testes realizados em cada módulo individualmente.
- Apresentar imagens ou tabelas com os resultados das simulações (como capturas do GTKWave, se for o caso).
- Discutir o que foi observado nos testes.
- Analisar o desempenho do sistema e a correção das funcionalidades.
- Como lidar com limitações ou melhorias futuras, comente aqui também.

## Colaboradores

Este projeto foi desenvolvido por:

- [**Guilherme Fernandes Sardinha**](https://github.com/DrizinCoder) – desenvolvimento da Unidade de controle, simulações/testes e escrita do relatório  
- [**Robson Carvalho de Souza**](https://github.com/Robson-Carvalho) – lógica da ULA, simulações/testes e escrita do relatório
- [**Lucas Damasceno da Conceição**] – suporte na ULA e escrita do relatório  

Agradecimentos ao(a) professor(a) [**Wild Freitas da Silva Santos**] pela orientação.


---

