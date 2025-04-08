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

## Unidade de Controle

A **unidade de controle** é o componente responsável por processar as instruções, gerenciar o fluxo de dados e coordenar os outros componentes internos, funcionando como um organizador geral do sistema. Sua função é crucial para garantir a execução eficiente das operações, especialmente no contexto de processamentos matriciais.

A unidade de controle gerencia a comunicação entre a **memória RAM**, que armazena as matrizes a serem manipuladas, e os demais componentes, como a **ULA (Unidade Lógica e Aritmética)**, responsável pelo processamento aritmético das matrizes. Ela também desempenha um papel fundamental na **sincronização geral do sistema**, garantindo que todas as operações ocorram no tempo correto e de maneira ordenada.

Em termos de desempenho, a unidade de controle é o "cérebro" do sistema, sendo responsável por organizar e orquestrar as etapas de cada operação matricial. Ela garante que os dados sejam lidos da memória na ordem correta, que as operações sejam executadas corretamente pela ULA e que o fluxo de controle seja mantido sem erros durante o processamento das matrizes.

### Instruction Set Architecture

As instruções desenvolvidas para o coprocessador seguem um padrão uniforme para todos os tipos de operações realizadas, sejam elas de transferência de dados ou operações aritméticas. Essa decisão de projeto foi tomada com o objetivo de simplificar a complexidade associada à implementação das instruções, assegurando que a etapa de decodificação fosse generalizada e simplificada.
As instruções possuem um tamanho fixo de 8 bits e a estrutura das instruções é organizada da seguinte forma:

![Formato da instrução](<images/Diagrama%20de%20blocos%20(14).jpg>)

Os campos da instrução são definidos por:
| Atributo | Descrição |
|----------|-----------|
| **MT** | Matriz alvo do carregamento (A ou B) |
| **M_Size** | Tamanho da matriz utilizado por operações de movimentação de dados e aritméticas |
| **OPCODE** | Código de operação |

Conjunto de instruções do coprocessador:

### Instruções aritméticas e seus Códigos Hexadecimais

| Instrução                            | Código Hexadecimal |
| ------------------------------------ | ------------------ |
| **Soma**                             | `0x01`             |
| **Subtração**                        | `0x02`             |
| **Multiplicação**                    | `0x03`             |
| **Multiplicação por número inteiro** | `0x04`             |
| **Transposição**                     | `0x05`             |
| **Matriz Oposta**                    | `0x06`             |
| **Determinante 2x2**                 | `0x17`             |
| **Determinante 3x3**                 | `0x1F`             |
| **Determinante 4x4**                 | `0x27`             |
| **Determinante 5x5**                 | `0x2F`             |

### Instruções de movimentação de dados e seus Códigos Hexadecimais

| Instrução                 | Código Hexadecimal |
| ------------------------- | ------------------ |
| **Carregar matriz A 2x2** | `0x10`             |
| **Carregar matriz A 3x3** | `0x18`             |
| **Carregar matriz A 4x4** | `0x20`             |
| **Carregar matriz A 5x5** | `0x28`             |
| **Carregar matriz B 2x2** | `0x50`             |
| **Carregar matriz B 3x3** | `0x58`             |
| **Carregar matriz B 4x4** | `0x60`             |
| **Carregar matriz B 5x5** | `0x68`             |

### Etapas de processamento

As etapas de processamento do sistema são definidas por meio de uma máquina de estados finitos (FSM), responsável por receber e interpretar as instruções. Para o desenvolvimento dessa parte, foi necessário compreender como co-processadores realizam o recebimento e a execução de comandos. A partir desse estudo, foram definidos os seguintes estágios da FSM de processamento:

---

#### - Fetch

O estado Fetch representa a etapa inicial do fluxo de processamento. Sua principal função é realizar a busca da instrução na memória. No sistema implementado, essa busca ocorre no endereço 0x0, reservado exclusivamente para o armazenamento da instrução atual.  
A FSM aguarda um sinal de controle denominado "start process”, que indica a alocação de uma nova instrução no endereço especificado. Ao receber esse sinal, a FSM extrai os dados da posição de memória e os transfere para um registrador interno, o qual será utilizado na etapa seguinte do processamento.

---

#### - Decode

O estado Decode tem como função interpretar a instrução capturada durante a etapa de Fetch. Nessa fase, o sistema realiza a separação dos campos presentes na instrução e os aloca em registradores de controle apropriados. Esses registradores são essenciais para orientar o fluxo de dados e definir o comportamento da máquina nas etapas subsequentes do processamento.

---

#### - Execute

O estado Execute é responsável por processar as informações contidas na instrução decodificada. Nessa etapa, o coprocessador realiza operações de leitura na memória ou delega à ULA (Unidade Lógica e Aritmética) a execução das operações aritméticas sobre as matrizes. Trata-se da fase central de todo o sistema, onde as instruções são efetivamente aplicadas, garantindo que os cálculos e movimentações de dados ocorram de forma correta e consistente.

---

#### - WriteBack

O estado de writeback é responsável por escrever na memória a matriz resultante do processamento aritmético. Essa etapa assegura que os dados processados pela ULA estejam disponíveis para o processador no endereço de memória adequado.

---

#### - CleanUP

O estado CleanUP é responsável por reiniciar todos os registradores de controle da FSM, assegurando que o processamento não seja comprometido por resíduos de dados anteriores. A inclusão deste estágio mostrou-se vantajosa para evitar possíveis erros de metaestabilidade e garantir um ambiente limpo para a próxima operação. Após a conclusão desta etapa, o sistema retorna ao estado Fetch, aguardando uma nova sinalização de início de processamento.

### Fluxos de Execução da FSM

O sistema possui dois fluxos de execução distintos que ocorrem na FSM, ambos projetados para realizar as operações de maneira otimizada, evitando desperdício de ciclos e assegurando um processamento eficiente.

---

#### Primeiro Fluxo: Leitura de Matrizes

O primeiro fluxo diz respeito à leitura das matrizes a partir da memória. Nesse processo de movimentação de dados, não há necessidade de realizar escrita, uma vez que ainda não foram processadas informações. Para evitar o uso desnecessário de ciclos e otimizar a execução, o processador segue o seguinte caminho:

**Fetch → Decode → Execute → CleanUp**

Essa abordagem garante agilidade ao evitar a passagem por estados que não são essenciais neste contexto específico.

---

#### Segundo Fluxo: Processamento Aritmético

O segundo fluxo está relacionado ao processamento aritmético das matrizes. Após a realização das operações, a matriz resultante deve ser armazenada novamente na memória. Para isso, o estado `WriteBack` é ativado, realizando a escrita dos dados no local apropriado. O fluxo de execução neste caso é:

**Fetch → Decode → Execute → WriteBack → CleanUp**

Essa decisão de projeto foi adotada com o intuito de evitar o trânsito desnecessário dos dados por estágios irrelevantes ao seu tipo de operação, otimizando o tempo de execução e assegurando maior eficiência no processamento.

### Banco de Registradores

O banco de registradores é uma subdivisão essencial em qualquer co-processador, funcionando como uma área de armazenamento temporário para os dados manipulados durante a execução das instruções. No sistema desenvolvido, essa estrutura foi projetada com o objetivo de garantir agilidade no acesso às informações, reduzindo o tempo necessário para buscar dados diretamente na memória principal.

#### Diagrama Funcional

---

<img src="images/BancoDeReg.png" width="200"/>

---

#### Tipos de Registradores

| Tipo                          | Função                                                                              |
| ----------------------------- | ----------------------------------------------------------------------------------- |
| **Registradores de Dados**    | Armazenam matrizes e operandos utilizados nas operações. Ligados à ULA e à memória. |
| **Registradores de Controle** | Guardam os campos extraídos das instruções, definindo o fluxo de execução.          |

A separação entre registradores de dados e de controle torna o sistema mais modular, facilitando o entendimento do fluxo de informações dentro do co-processador e otimizando sua implementação. Além disso, esse modelo contribui para a escalabilidade do projeto, permitindo futuras expansões ou adaptações com maior facilidade.

## Módulo de memória

### Leitura e escrita dos dados a partir da memória

### Sincronização

## 🧮 ULA (Unidade Lógica-Aritmética)

### 💡 O que é uma ULA?

A Unidade Lógica-Aritmética (ULA) é o componente responsável por realizar operações matemáticas em processadores ou co-processadores especializados em cálculos específicos.

No contexto deste projeto, a ULA foi desenvolvida como parte da primeira avaliação da disciplina MI - Sistemas Digitais, sendo integrada a um co-processador especializado em operações matriciais.

Uma Unidade Lógica-Aritmética se trata do componente responsável por realziar as operações nos processadores ou co-processadores especialziados em cálculos específicos. No contexto do problema, a ULA desenvolvida para o co-processador, requisitado como primeira avaliação da disciplina MI - Sistemas Digitais, é especializado em operações matriciais.

### ⚒️ Operações suportadas.

Atualmente, a ULA implementa as seguintes operações matriciais:

- Soma
- Subtração
- Multiplicação
- Transposição
- Matriz Oposta
- Produto por Escalar
- Cálculo de Determinante

#### 🔁 Operações com Lógica Combinacional

As operações de soma, subtração, transposição, matriz oposta e produto por escalar são realizadas em apenas um ciclo de clock, utilizando lógica combinacional.

#### ⚙️ Multiplicação com Shift and Add

Para a operação de multiplicação, a técnica Shift and Add foi adotada com o objetivo de reduzir o consumo de DSP Blocks — blocos especializados em multiplicação que são recursos escassos na FPGA [DE1-SoC](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836). Essa técnica consiste em realizar deslocamentos de bits seguidos de somas, ao invés da multiplicação convencional.

#### 📐 Determinante com Cálculo Sequencial

O cálculo de determinantes para matrizes quadradas de ordem N ≥ 3 é uma operação computacionalmente complexa. Portanto, foi implementado de forma sequencial, tornando o processo mais viável em termos de desempenho e uso de recursos.

#### 📥 Como a ULA recebe os dados e sinais de controle

Após a UC [(Unidade de Controle)](#unidade-de-controle) obter as matrizes e o opcode da operação, ela realiza a tratativa e o empacotamento dos dados. Em seguida, envia para a ULA 25 bytes, cada um representando um elemento da matriz máxima suportada: uma matriz quadrada 5x5.

Essa padronização permite que a ULA opere diretamente sobre o conjunto de dados sem a necessidade de redefinir estruturas internas para diferentes dimensões de matriz.

#### 📤 Como os resultados são manipulados e retornados

A ULA opera sempre com matrizes de ordem 5x5, mesmo quando a matriz de entrada possui uma ordem inferior (como 2x2 ou 4x4). Para operações como soma, subtração, transposição, matriz oposta, produto por escalar e multiplicação de matrizes, o tamanho real da matriz não influencia no resultado, pois os elementos fora da região válida são preenchidos com zero.

Essa estratégia permite que todas as operações sejam realizadas por um único módulo, otimizando a lógica e facilitando o suporte a diferentes dimensões de matrizes de forma unificada.

Os valores são preenchidos corretamente nos espaços correspondentes da "fita de bytes", que posteriormente é retornada à UC (Unidade de Controle) para processamento ou exibição.

#### ⚠️ Atenção ao cálculo do determinante:

Para a operação de determinante, o tamanho da matriz impacta diretamente o resultado. Por isso, é utilizado o [Teorema de Laplace](https://pt.wikipedia.org/wiki/Teorema_de_Laplace), e há um módulo dedicado para cada tamanho de matriz, garantindo precisão no cálculo para matrizes de diferentes ordens.

## 🧪 Testes e Simulações

A metodologia de Testes usada para garantir o correto funcionamento da ULA foram conduzidos em duas etapas:

Simulação via Icarus Verilog, inicialmente, todos os módulos foram testados de forma isolada utilizando o simulador Icarus Verilog. Após a validação por simulação, o projeto foi sintetizado no ambiente Quartus Prime II e implementado na placa DE1-SoC, replicando o ambiente final de operação do co-processador.

## 🧷 Testes Individuais por Operação

Cada operação foi testada com diferentes matrizes de entrada, garantindo cobertura para:

## 📈 Análise dos Resultados

Os testes revelaram que:

- ✅ As operações de lógica combinacional foram executadas corretamente em um único ciclo de clock, apresentando excelente desempenho.

- ✅ A operação de multiplicação por Shift and Add mostrou-se eficiente no uso de recursos, consumindo significativamente menos DSPs que a multiplicação direta.

- ⚠️ O cálculo do determinante, por ser realizado de forma sequencial, demandou mais ciclos de clock. No entanto, a divisão por módulos específicos para cada ordem de matriz tornou o tempo aceitável para o contexto do projeto.

- ✅ O preenchimento das regiões inválidas da matriz com zero funcionou corretamente, mantendo a integridade dos dados para ordens menores.

## 📉 Desempenho e Uso de Recursos

Durante a síntese no Quartus Prime II, foram observadas as seguintes métricas relevantes:

<div align="center">
  <br/>

  <img  src="" width="50%" alt="Imagem dos recursos utilizados"/>

  <br/>
  <br/>
</div>

- Baixo consumo de **DSP Blocks**, uma vez que foi visado o baixo uso do recurso, por ser escasso, assim deixar para utilização de outros componentes de controle e etc.

- Utilização moderada de **ALMs**, uma vez que é um recurso abundante. Dessa forma, optamos por utiliza-lô de maneira modearada.

## 💭 Discussões e Melhorias Futuras

Embora a ULA tenha se comportado conforme o esperado, algumas melhorias podem ser consideradas:

- 🧮 Cálculo otimizado de determinante: explorar técnicas como eliminação de Gauss para reduzir a complexidade sequencial.

- 🧩 Suporte a matrizes não quadradas: possibilidade futura de expansão do módulo para aceitar operações com matrizes de diferentes dimensões.

## ✍️ Colaboradores

Este projeto foi desenvolvido por:

- [**Guilherme Fernandes Sardinha**](https://github.com/DrizinCoder) – Desenvolvimento da Unidade de controle, simulações, testes e escrita do relatório.
- [**Robson Carvalho de Souza**](https://github.com/Robson-Carvalho) – Desenvolvimento da ULA (Unidade Lógica-Aritmética), simulações, testes e escrita do relatório.
- [**Lucas Damasceno da Conceição**](https://github.com/Lucas-Damasceno-dev/calculoDeterminante/blob/main/determinant5x5_expansion.v) – Suporte na ULA e escrita do relatório.

Agradecimentos ao(a) professor(a) [**Wild Freitas da Silva Santos**] pela orientação.

---
