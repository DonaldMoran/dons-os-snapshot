#include <stdint.h>
#include "include/vga.h"

#define PIC1_CMD  0x20
#define PIC1_DATA 0x21
#define PIC2_CMD  0xA0
#define PIC2_DATA 0xA1

#define PIC_EOI   0x20

#define PIT_CH0      0x40
#define PIT_CMD      0x43

#define PIT_MODE     0x36   // Channel 0, Lo/Hi byte, mode 3 (square wave)

#define KBD_DATA 0x60
#define KBD_STATUS 0x64

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

void pic_remap(void) {
    uint8_t a1 = inb(PIC1_DATA);
    uint8_t a2 = inb(PIC2_DATA);

    outb(PIC1_CMD, 0x11);
    outb(PIC2_CMD, 0x11);

    outb(PIC1_DATA, 0x20);
    outb(PIC2_DATA, 0x28);

    outb(PIC1_DATA, 0x04);
    outb(PIC2_DATA, 0x02);

    outb(PIC1_DATA, 0x01);
    outb(PIC2_DATA, 0x01);

    outb(PIC1_DATA, a1);
    outb(PIC2_DATA, a2);
}

static volatile uint64_t g_ticks = 0;

void irq0_handler(void) {
    g_ticks++;

    // Example: print every 100 ticks (~1 second at 100 Hz)
    if (g_ticks % 100 == 0) {
        //vga_print("Tick\n");
        vga_print_at(0, 0, "Tick: ");
        vga_print_dec(0, 6, g_ticks);
    }

    outb(PIC1_CMD, PIC_EOI);
}

void irq1_handler(void) {
    uint8_t sc = inb(KBD_DATA);
    vga_print_at(1, 0, "Scancode: ");
    vga_print_hex(1, 11, sc);
    outb(PIC1_CMD, PIC_EOI);
}


void isr0_handler(void) {
    vga_print("EXCEPTION: Divide by zero\n");
    while (1) { }
}

void isr1_handler(void) {
    vga_print("EXCEPTION: Debug\n");
}

void pit_init(uint32_t freq) {
    uint32_t divisor = 1193180 / freq;   // PIT base clock

    outb(PIT_CMD, PIT_MODE);
    outb(PIT_CH0, divisor & 0xFF);        // low byte
    outb(PIT_CH0, (divisor >> 8) & 0xFF); // high byte
}
