#include <io.h>
#include <system.h>


unsigned char seven_seg[16] = {
    0x3F,
    0x06,
    0x5B,
    0x4F,
    0x66,
    0x6D,
    0x7D,
    0x07,
    0x7F,
    0x6F,
    0x77,
    0x7C,
    0x39,
    0x5E,
    0x79,
    0x71
};

void main() {
    int temp;
    while (1) {
        temp = IORD(SWITCH_BASE, 0) & 0x0F;

        IOWR(HEX0_BASE, 0, ~seven_seg[temp]);
    }
}
