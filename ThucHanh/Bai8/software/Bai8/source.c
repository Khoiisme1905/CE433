#include <stdio.h>
#include "system.h"
#include "altera_avalon_dma_regs.h"
#include "sys/alt_irq.h"
//Code su dung DMA de chuyen du lieu tu memory nay sang memory khac, su dung ngat de thong bao dma hoan thanh
// pdata0 points to a global array stored in onchip_memory2_0
char pdata0[32] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                   16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
// pdata1 points to onchip_memory2_1
char *pdata1 = (char *)(ONCHIP_MEMORY2_1_BASE);
// Interrupt handler of DMA
void DMA_ISR_Handler(void *isr_context)
{
    int i;
    // Read and print data in onchip_memory2_1
    printf("DMA transfer complete. Data in destination memory:\n");
    for (i = 0; i < 32; i++)
    {
        printf("byte %d = %d\n", i, pdata1[i]);
    }
    // Clear DMA Interrupt bit
    IOWR_ALTERA_AVALON_DMA_STATUS(DMA_0_BASE, 0);
}
// Initialize funciton of DMA
void DMA_Init(void)
{
    // De-init DMA, dung dma
    IOWR_ALTERA_AVALON_DMA_CONTROL(DMA_0_BASE, 0);
    // Source address is pdata0, cau hinh dia chi nguon
    IOWR_ALTERA_AVALON_DMA_RADDRESS(DMA_0_BASE, (int)pdata0);
    // Destination address is pdata1, cau hinh dia chi dich
    IOWR_ALTERA_AVALON_DMA_WADDRESS(DMA_0_BASE, (int)pdata1);
    // Length is 32 bytes, cau hinh do dai transfer
    IOWR_ALTERA_AVALON_DMA_LENGTH(DMA_0_BASE, 32);
    // Configure and Start DMA with byte transfer, end transaction when
    // length reach zero, interrupt enable and start DMA
    IOWR_ALTERA_AVALON_DMA_CONTROL(DMA_0_BASE,
                                   ALTERA_AVALON_DMA_CONTROL_BYTE_MSK | //transfer tung byte
                                       ALTERA_AVALON_DMA_CONTROL_LEEN_MSK | //dung khi length = 0
                                       ALTERA_AVALON_DMA_CONTROL_I_EN_MSK | //bat interrupt
                                       ALTERA_AVALON_DMA_CONTROL_GO_MSK); //bat dau dma
}
int main()
{
    DMA_Init();
    alt_ic_isr_register(DMA_0_IRQ_INTERRUPT_CONTROLLER_ID, DMA_0_IRQ,
                        DMA_ISR_Handler, NULL, NULL);
    while (1)
    {
    }
    return 0;
}
