#include <system.h>
#include <altera_avalon_pio_regs.h>
#include <altera_avalon_timer_regs.h>
#include <sys/alt_irq.h>

// Dinh nghia timer, sw, hex
#define TIMER_BASE TIMER_0_BASE
#define SW_BASE SW_BASE
#define HEX_BASE HEX_BASE

// Khoi tao timer
void init_timer() {
    // Cau hinh timer de dem 1s
    IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_BASE, 0xC350); // Thap 16 bit
    IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_BASE, 0x2FAF); // Cao 16 bit (50,000,000 = 0x2FAF_C350)
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_BASE, 0x7); // Start, Continuous, Enable IRQ
}

// Chuyen doi thanh Hex
int hex_digit(int digit) {
    switch (digit) {
        case 0: return 0x3F; // 0
        case 1: return 0x06; // 1
        case 2: return 0x5B; // 2
        case 3: return 0x4F; // 3
        case 4: return 0x66; // 4
        case 5: return 0x6D; // 5
        case 6: return 0x7D; // 6
        case 7: return 0x07; // 7
        case 8: return 0x7F; // 8
        case 9: return 0x6F; // 9
        default: return 0x00; // Tat
    }
}

// Hien thi gia tri len Hex
void display_hex(int seconds) {
    int hex0 = hex_digit(seconds % 10);       // Giay (don vi)
    int hex1 = hex_digit((seconds / 10) % 6); // Giay (chuc)
    int hex2 = hex_digit((seconds / 60) % 10); // Phut (don vi)
    int hex3 = hex_digit((seconds / 600) % 6); // Phut (chuc)

    // Ghi gia tri vao hex
    int hex_value = (hex3 << 21) | (hex2 << 14) | (hex1 << 7) | hex0;
    IOWR_ALTERA_AVALON_PIO_DATA(HEX_BASE, hex_value);
}

int main() {
    int seconds = 0;

    // Khoi tao timer
    init_timer();

    while (1) {
        // Doi timer 1s
        while (!(IORD_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE) & 0x1));
        IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_BASE, 0);

        // Tang giay
        seconds = (seconds + 1) % 3600; // Reset sau 1h
        display_hex(seconds);
    }

    return 0;
}
