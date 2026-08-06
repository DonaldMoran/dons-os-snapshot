#include <stdint.h>
#include "include/vga.h"

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_MEM    ((uint16_t *)0xB8000)

static int cursor_row = 3;   // start on line 3
static int cursor_col = 0;
static uint8_t cursor_attr = 0x07; // light grey on black

void vga_putc(char c) {
    if (c == '\n') {
        cursor_row++;
        cursor_col = 0;
        if (cursor_row >= VGA_HEIGHT)
            cursor_row = VGA_HEIGHT - 1;
        return;
    }

    if (c == '\b') {
        if (cursor_col > 0) {
            cursor_col--;
            VGA_MEM[cursor_row * VGA_WIDTH + cursor_col] =
                ((uint16_t)cursor_attr << 8) | ' ';
        }
        return;
    }

    VGA_MEM[cursor_row * VGA_WIDTH + cursor_col] =
        ((uint16_t)cursor_attr << 8) | (uint8_t)c;

    cursor_col++;
    if (cursor_col >= VGA_WIDTH) {
        cursor_col = 0;
        cursor_row++;
        if (cursor_row >= VGA_HEIGHT)
            cursor_row = VGA_HEIGHT - 1;
    }
}

void vga_print(const char *s) {
    while (*s) {
        vga_putc(*s++);
    }
}

void vga_print_at(int row, int col, const char *s) {
    int saved_row = cursor_row;
    int saved_col = cursor_col;

    cursor_row = row;
    cursor_col = col;

    while (*s) {
        vga_putc(*s++);
    }

    cursor_row = saved_row;
    cursor_col = saved_col;
}

void vga_print_hex(int row, int col, uint64_t val) {
    static const char hex[] = "0123456789ABCDEF";

    int saved_row = cursor_row;
    int saved_col = cursor_col;

    cursor_row = row;
    cursor_col = col;

    for (int i = 15; i >= 0; i--) {
        uint8_t nibble = (val >> (i * 4)) & 0xF;
        vga_putc(hex[nibble]);
    }

    cursor_row = saved_row;
    cursor_col = saved_col;
}

void vga_print_dec(int row, int col, uint64_t val) {
    char buf[32];
    int idx = 31;
    buf[idx--] = '\0';

    if (val == 0) {
        buf[idx] = '0';
    } else {
        while (val > 0 && idx >= 0) {
            buf[idx--] = '0' + (val % 10);
            val /= 10;
        }
    }

    vga_print_at(row, col, &buf[idx]);
}
