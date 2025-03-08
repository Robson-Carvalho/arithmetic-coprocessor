#include <stdio.h>      
#include <stdlib.h>     // Funções básicas (malloc, free, exit)
#include <fcntl.h>      // Controle de arquivos (open, O_RDWR)
#include <sys/mman.h>   // Mapeamento de memória (mmap, munmap)
#include <unistd.h>     // Funções de sistema (close, usleep)

#define FPGA_BASE  0xC0000000      // Endereço da HPS-to-FPGA AXI Master Bridge (para enviar números)
#define LIGHTWEIGHT_BASE 0xFF200000 // Endereço da Lightweight HPS-to-FPGA Bridge (para controle)
#define FPGA_TO_HPS  0xC0100000     // Endereço da FPGA-to-HPS Bridge (para receber resultado)
#define FPGA_SPAN  0x00200000       // Espaço de memória mapeado (tamanho)

int main(){
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1) {
        printf("Erro ao abrir /dev/mem\n");
        return -1;
    }

    // Mapeamento de memória
    void *fpga_base = mmap(NULL, FPGA_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, FPGA_BASE);
    volatile unsigned int *num_mem = (unsigned int *)fpga_base;

    void *lightweight_base = mmap(NULL, FPGA_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LIGHTWEIGHT_BASE);
    volatile unsigned int *instruction_mem = (unsigned int *)lightweight_base;

    void *fpga_result = mmap(NULL, FPGA_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, FPGA_TO_HPS);
    volatile unsigned int *result_mem = (unsigned int *)fpga_result;

    // Enviando dois números para a FPGA
    num_mem[0] = 5;  // Primeiro número
    num_mem[1] = 7;  // Segundo número
    
    // Enviar instrução de soma para a FPGA
    instruction_mem[0] = 1;  // Código 1 pode representar soma

    // Espera ativa pelo sinal de pronto (ready flag)
    while (result_mem[1] == 0);  // Espera até FPGA escrever 1 (sinalizando que o resultado está pronto)

    printf("Resultado da soma: %d\n", result_mem[0]);

    // Resetar flag de pronto
    result_mem[1] = 0;

    // Liberar memória
    munmap(fpga_base, FPGA_SPAN);
    munmap(lightweight_base, FPGA_SPAN);
    munmap(fpga_result, FPGA_SPAN);
    close(fd);

    return 0;
}
