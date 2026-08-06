#include <stdint.h>
#include "include/keyboard.h"

#define KBD_BUFFER_SIZE 128

static char kbd_buffer[KBD_BUFFER_SIZE];
static int  kbd_head = 0;
static int  kbd_tail = 0;

void keyboard_init(void) {
    kbd_head = 0;
    kbd_tail = 0;
}

int kbd_buffer_put(char c) {
    int next = (kbd_head + 1) % KBD_BUFFER_SIZE;

    if (next == kbd_tail)
        return 0; // buffer full

    kbd_buffer[kbd_head] = c;
    kbd_head = next;
    return 1;
}

int kbd_buffer_get(char *c) {
    if (kbd_head == kbd_tail)
        return 0; // buffer empty

    *c = kbd_buffer[kbd_tail];
    kbd_tail = (kbd_tail + 1) % KBD_BUFFER_SIZE;
    return 1;
}

// ASCII table for letters
static const char scancode_ascii[128] = {
    [0x10] = 'q',
    [0x11] = 'w',
    [0x12] = 'e',
    [0x13] = 'r',
    [0x14] = 't',
    [0x15] = 'y',
    [0x16] = 'u',
    [0x17] = 'i',
    [0x18] = 'o',
    [0x19] = 'p',
    [0x1E] = 'a',
    [0x1F] = 's',
    [0x20] = 'd',
    [0x21] = 'f',
    [0x22] = 'g',
    [0x23] = 'h',
    [0x24] = 'j',
    [0x25] = 'k',
    [0x26] = 'l',
    [0x2C] = 'z',
    [0x2D] = 'x',
    [0x2E] = 'c',
    [0x2F] = 'v',
    [0x30] = 'b',
    [0x31] = 'n',
    [0x32] = 'm',
};

char scancode_to_ascii(uint8_t sc, int shift, int caps) {
    // break code: ignore
    if (sc & 0x80)
        return 0;

    uint8_t code = sc & 0x7F;

    // space
    if (code == 0x39)
        return ' ';

    // backspace
    if (code == 0x0E)
        return '\b';

    if (code >= 128)
        return 0;

    char ch = scancode_ascii[code];
    if (!ch)
        return 0;

    // letters: apply shift/caps
    if (ch >= 'a' && ch <= 'z') {
        int upper = (shift ^ caps);
        if (upper)
            ch = (char)(ch - 'a' + 'A');
    }

    return ch;
}
