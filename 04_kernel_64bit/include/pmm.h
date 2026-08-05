#pragma once
#include <stdint.h>
#include "bootinfo.h"

#define PAGE_SIZE 4096

void pmm_init(BootInfo *info);

uint64_t pmm_alloc_page(void);
void pmm_free_page(uint64_t phys_addr);
