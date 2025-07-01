#include <stdio.h>
#include "io.h"
#include "system.h"
#include "altera_avalon_timer_regs.h"
#include "sys/alt_irq.h"

unsigned int counter = 0;

void timer_Init(){
    unsigned int period = 0;
    // Stop Timer
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE,
        ALTERA_AVALON_TIMER_CONTROL_STOP_MSK);
    //Configure period
    //Timer tao ngat deu dan moi mot giay (50 trieu chu ky clock = 1 giay)
    period = 50000000 - 1; //timer dem xuong, khi bang 0 -> ngat
    IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_0_BASE, period);
    IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_0_BASE, (period >> 16));

    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE,
        ALTERA_AVALON_TIMER_CONTROL_CONT_MSK | // Continue counting mode
        ALTERA_AVALON_TIMER_CONTROL_ITO_MSK | // Interrupt enable //bat tat ngat dinh thoi (cong tac)
        ALTERA_AVALON_TIMER_CONTROL_START_MSK);// Start Timer
}

void Timer_IRQ_Handler(void* isr_context){
    counter ++;
    printf("%d seconds\n", counter);
    // Clear Timer interrupt bit
    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE,
        ALTERA_AVALON_TIMER_STATUS_TO_MSK);
}

int main(){
    timer_Init();
    alt_ic_isr_register(0, TIMER_0_IRQ, Timer_IRQ_Handler, (void*)0,
        (void*)0); //Khi timer tran, ngat tu dong xay ra
    while(1);

    return 0;
}
