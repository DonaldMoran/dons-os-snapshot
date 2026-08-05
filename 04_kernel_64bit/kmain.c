#include <stdint.h>
//#include "include/bootinfo.h"
#include "include/pmm.h"

static volatile uint16_t *const VGA = (uint16_t *)0xB8000;

static void vga_print_at(int row, int col, const char *s) {
    int pos = row * 80 + col;
    while (*s) {
        VGA[pos++] = (0x07 << 8) | *s++;
    }
}

static void vga_print_hex(int row, int col, uint64_t val) {
    const char *hex = "0123456789ABCDEF";
    int pos = row * 80 + col;

    for (int i = 60; i >= 0; i -= 4) {
        VGA[pos++] = (0x07 << 8) | hex[(val >> i) & 0xF];
    }
}

static void vga_print_dec(int row, int col, uint64_t val) {
    char buf[32];
    int i = 0;

    if (val == 0) {
        VGA[row * 80 + col] = (0x07 << 8) | '0';
        return;
    }

    while (val > 0 && i < (int)(sizeof(buf) - 1)) {
        buf[i++] = '0' + (val % 10);
        val /= 10;
    }

    int pos = row * 80 + col;
    while (i--) {
        VGA[pos++] = (0x07 << 8) | buf[i];
    }
}

void kmain(BootInfo *info) {
    // clear screen
    for (int i = 0; i < 80 * 25; i++) {
        VGA[i] = (0x07 << 8) | ' ';
    }

    vga_print_at(2, 30, "KERNEL64 FROM C");

    // BootInfo values
    vga_print_at(4, 10, "PML4 addr: ");
    vga_print_hex(4, 22, info->pml4_addr);

    vga_print_at(5, 10, "Kernel phys start: ");
    vga_print_hex(5, 30, info->kernel_phys_start);

    vga_print_at(6, 10, "Kernel phys end: ");
    vga_print_hex(6, 28, info->kernel_phys_end);

    // E820 memory map
    vga_print_at(8, 10, "E820 entries: ");
    vga_print_dec(8, 24, info->memory_map_count);

    MemoryMapEntry *m = (MemoryMapEntry *)info->memory_map_addr;

    uint64_t total_usable = 0;

    int row = 10;
    for (uint64_t i = 0; i < info->memory_map_count && row < 22; i++, row++) {
        // Print each entry
        vga_print_at(row, 2, "Base: ");
        vga_print_hex(row, 9, m[i].base);

        vga_print_at(row, 28, "Len: ");
        vga_print_hex(row, 34, m[i].length);

        vga_print_at(row, 60, "T:");
        vga_print_dec(row, 63, m[i].type);

        // Sum usable RAM (type 1)
        if (m[i].type == 1) {
            total_usable += m[i].length;
        }
    }

    // Print total usable RAM
    vga_print_at(23, 2, "Total usable RAM (bytes): ");
    vga_print_hex(23, 30, total_usable);

    vga_print_at(24, 2, "Total usable RAM (MB): ");
    vga_print_dec(24, 28, total_usable / (1024 * 1024));

    // ----------------------------------------------------
    // Initialize Physical Memory Manager (PMM)
    // ----------------------------------------------------
    pmm_init(info);
	
    // Allocate a few pages to test the allocator
    uint64_t page1 = pmm_alloc_page();
    uint64_t page2 = pmm_alloc_page();
    uint64_t page3 = pmm_alloc_page();

    vga_print_at(18, 2, "Alloc page1: ");
    vga_print_hex(18, 16, page1);
	
    vga_print_at(19, 2, "Alloc page2: ");
    vga_print_hex(19, 16, page2);
	
    vga_print_at(20, 2, "Alloc page3: ");
    vga_print_hex(20, 16, page3);

    for (;;);
}
