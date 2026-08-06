#pragma once
#include <stdint.h>

void vga_putc_at(int row, int col, char c);
void vga_print_at(int row, int col, const char *s);
void vga_print_hex(int row, int col, uint64_t val);
void vga_print_dec(int row, int col, uint64_t val);
void vga_print(const char *s);
void vga_clear(void);
