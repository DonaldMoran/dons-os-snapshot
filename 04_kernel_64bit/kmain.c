#include <stdint.h>

static volatile uint16_t *const VGA = (uint16_t *)0xB8000;

void kmain(void) {
    // clear screen
    for (int i = 0; i < 80 * 25; i++) {
        VGA[i] = (0x07 << 8) | ' ';
    }

    const char *msg = "KERNEL64 FROM C";
    int row = 12;
    int col = 30;
    int pos = row * 80 + col;

    for (const char *p = msg; *p; p++) {
        VGA[pos++] = (0x07 << 8) | *p;
    }

    for (;;)
        ;
}
