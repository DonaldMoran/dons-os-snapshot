#pragma once
#include <stdint.h>

#ifndef KEYBOARD_H
#define KEYBOARD_H

void keyboard_init(void);
void keyboard_isr(void);

int  kbd_buffer_put(char c);   // FIXED: return int
int  kbd_buffer_get(char *c);

char scancode_to_ascii(uint8_t sc, int shift, int caps);

#endif
