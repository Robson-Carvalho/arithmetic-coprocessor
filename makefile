# Nome do arquivo de simulação
TOP_TEST = top_test.v

# Diretórios dos módulos
MODULES = \
    modules/alu_sum_module.v \
    modules/alu_subtraction_module.v \
    modules/alu_multiplication_module.v \
    modules/alu_opposite_module.v \
    modules/alu_transpose_module.v \
    modules/alu_scalar_module.v \
    modules/alu.v \
    modules/alu_determinant_module.v \
    modules/determinant2x2.v \
    modules/determinant3x3.v \
    modules/determinant4x4.v \
    modules/determinant5x5.v \

# Nome do arquivo de saída da simulação
OUTPUT = test/simulation

# Comando de compilação e simulação
IVERILOG = iverilog

# Comando para rodar a simulação
VVP = vvp

# Alvo principal
all: $(OUTPUT)

# Como compilar e gerar a simulação
$(OUTPUT): $(TOP_TEST) $(MODULES)
	$(IVERILOG) -o $(OUTPUT) $(TOP_TEST) $(MODULES)

# Como rodar a simulação
run: $(OUTPUT)
	$(VVP) $(OUTPUT)

# Limpeza dos arquivos gerados
clean:
	rm -f $(OUTPUT)

# Alvo para simular e limpar em sequência
sim: all run clean
