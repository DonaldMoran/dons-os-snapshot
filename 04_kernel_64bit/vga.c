#include <stdint.h>
#include "vga.h"

static volatile uint16_t *const VGA = (uint16_t *)0xB8000;

void vga_putc_at(int row, int col, char c) {
    VGA[row * 80 + col] = (0x07 << 8) | c;
}

void vga_print_at(int row, int col, const char *s) {
    int pos = row * 80 + col;
    while (*s) {
        VGA[pos++] = (0x07 << 8) | *s++;
    }
}

void vga_print_hex(int row, int col, uint64_t val) {
    char buf[17];
    const char *hex = "0123456789ABCDEF";

    for (int i = 0; i < 16; i++) {
        buf[15 - i] = hex[(val >> (i * 4)) & 0xF];
    }
    buf[16] = 0;

    vga_print_at(row, col, buf);
}

void vga_print_dec(int row, int col, uint64_t val) {
    char buf[32];
    int i = 0;

    if (val == 0) {
        vga_print_at(row, col, "0");
        return;
    }

    while (val > 0) {
        buf[i++] = '0' + (val % 10);
        val /= 10;
    }

    // reverse
    for (int j = 0; j < i / 2; j++) {
        char tmp = buf[j];
        buf[j] = buf[i - j - 1];
        buf[i - j - 1] = tmp;
    }

    buf[i] = 0;
    vga_print_at(row, col, buf);
}

void vga_print(const char *s) {
    // print at top-left for interrupts
    int pos = 0;
    while (*s) {
        VGA[pos++] = (0x07 << 8) | *s++;
    }
}

void vga_clear(void) {
    for (int i = 0; i < 80 * 25; i++) {
        VGA[i] = (0x07 << 8) | ' ';
    }
}
