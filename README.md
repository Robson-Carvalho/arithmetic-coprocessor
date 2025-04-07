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

Explicar como o sistema foi desenvolvido, com foco na estrutura geral, divisão de módulos e lógica do projeto.

### Unidade de Controle
- Descrição da lógica da unidade de controle.
- Quais sinais ela gera e com que propósito.
- Como interage com outros módulos.

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

