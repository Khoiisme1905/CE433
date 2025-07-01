#include "sys/alt_stdio.h"
#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

void delay(int a)
{
    volatile int i = 0;
    while(i < a * 10000) {
        i++;
    }
}

void command(unsigned char data)
{
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_RS_BASE, 0x00);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_RW_BASE, 0x00);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_D_BASE, data & 0xFF);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_EN_BASE, 0x01);
    delay(20);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_EN_BASE, 0x00);
    delay(20);
}

void lcd_data(char data)
{
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_RS_BASE, 0x01);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_RW_BASE, 0x00);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_D_BASE, data & 0xFF);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_EN_BASE, 0x01);
    delay(20);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_EN_BASE, 0x00);
    delay(20);
}

void lcd_init()
{
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_ON_BASE, 0x01);
    IOWR_ALTERA_AVALON_PIO_DATA(LCD_BLON_BASE, 0x01);

    command(0x30);
    delay(500);
    command(0x30);
    delay(500);
    command(0x30);
    delay(500);

    command(0x38);
    delay(100);
    command(0x0C);
    delay(100);
    command(0x06);
    delay(100);
    command(0x01);
    delay(100);
}

void lcd_string(char *str)
{
    while(*str)
    {
        lcd_data(*str);
        str++;
    }
}

int main()
{
    lcd_init();

    command(0x80);

    lcd_string("DE2 KIT LCD TEST");

    command(0xC0);

    lcd_string("HELLO WORLD!");

    while(1)
    {
    }

    return 0;
}
