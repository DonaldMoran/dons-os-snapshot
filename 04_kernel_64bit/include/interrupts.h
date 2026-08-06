#pragma once

#ifndef INTERRUPTS_H
#define INTERRUPTS_H

#include <stdint.h>

void pic_remap(void);
void irq0_handler(void);
void irq1_handler(void);
void pit_init(uint32_t freq);

// Declare g_ticks as extern so kmain can access it
extern volatile uint64_t g_ticks;

#endif
