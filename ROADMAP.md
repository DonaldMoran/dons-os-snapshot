# ROADMAP  
### dons‑os (x86_64) — Project Roadmap

This roadmap outlines the planned evolution of **dons‑os**, beginning with the foundational boot stages and progressing toward a functional x86_64 kernel.  
Each milestone builds on the previous one, maintaining clarity, correctness, and educational value.

---

## 1. Boot Chain (Completed)

### ✔ 1.1 — 16‑bit Real Mode
- BIOS boot sector (`0x7C00`)
- INT 0x10 text output
- INT 0x13 disk loading
- Stage2 loader
- Minimal, clean real‑mode environment

### ✔ 1.2 — 32‑bit Protected Mode
- A20 line enabled
- GDT created and loaded
- CR0.PE → protected mode
- Far jump into 32‑bit code
- VGA text output in PM
- Stable flat memory model

### ✔ 1.3 — 64‑bit Long Mode
- PAE paging enabled
- PML4 → PDPT → PD → PT identity map
- IA32_EFER.LME set
- CR0.PG → paging enabled
- Far jump into 64‑bit code segment
- 64‑bit VGA text output
- Fully working long‑mode entry

The boot chain is complete and serves as the foundation for kernel development.

---

## 2. Kernel Foundations (Upcoming)

### ☐ 2.1 — Higher‑Half Kernel Layout
- Choose canonical base: `0xFFFFFFFF80000000`
- Map kernel text/data into higher half
- Update paging structures accordingly
- Prepare linker script

### ☐ 2.2 — Linker Script + C Runtime
- Create `linker.ld`
- Define `.text`, `.data`, `.bss`, `.rodata`
- Provide `_start` symbol for 64‑bit entry
- Implement minimal C runtime:
  - stack setup  
  - zero `.bss`  
  - call `kmain()`  

### ☐ 2.3 — 64‑bit IDT + Interrupts
- Build IDT in long mode
- Implement basic exception handlers
- Implement IRQ remapping (PIC)
- Add keyboard interrupt handler

### ☐ 2.4 — Serial Logging (COM1)
- Initialize COM1 (0x3F8)
- Provide `serial_write()` for debugging
- Optional: integrate with QEMU `-serial stdio`

---

## 3. Core Kernel Features

### ☐ 3.1 — Physical Memory Manager
- Parse memory map (BIOS or UEFI)
- Implement bitmap or buddy allocator
- Provide `alloc_page()` / `free_page()`

### ☐ 3.2 — Virtual Memory Manager
- Map/unmap pages dynamically
- Kernel heap allocator (kmalloc)
- Higher‑half identity map cleanup

### ☐ 3.3 — Basic Device Drivers
- Keyboard (PS/2)
- Text framebuffer (VGA or VBE)
- Serial port

### ☐ 3.4 — Timer + Scheduler Prototype
- PIT or HPET timer interrupts
- Task structure
- Cooperative or preemptive switching

---

## 4. User‑Facing Features

### ☐ 4.1 — Kernel Shell
- Basic command parser
- Built‑in commands:
  - `meminfo`
  - `cpuinfo`
  - `help`
  - `reboot`

### ☐ 4.2 — Improved Graphics (Optional)
- Switch from VGA text mode to framebuffer
- Draw pixels, rectangles, text
- Simple GUI experiments

---

## 5. Long‑Term Goals

### ☐ 5.1 — ELF Loader
- Load and execute user‑space ELF binaries
- Provide minimal syscall interface

### ☐ 5.2 — Virtual File System (VFS)
- Abstract filesystem layer
- RAMFS or simple FAT driver

### ☐ 5.3 — User‑Space Processes
- Paging isolation
- Syscalls
- Context switching

---

## 6. Development Tools

### ✔ QEMU Debug Mode
- `-d int,cpu_reset`
- `-no-reboot -no-shutdown`
- Essential for diagnosing triple faults

### ☐ GDB Remote Debugging
- Add `-s -S` support
- Document breakpoints for paging, mode switches

### ☐ Build Automation
- Top‑level Makefile (completed)
- Optional: `scripts/` directory for utilities

---

## Status Summary

| Stage | Status |
|-------|--------|
| 16‑bit real mode | ✔ Complete |
| 32‑bit protected mode | ✔ Complete |
| 64‑bit long mode | ✔ Complete |
| Higher‑half kernel | ☐ Planned |
| C runtime + linker | ☐ Planned |
| IDT + interrupts | ☐ Planned |
| Memory manager | ☐ Planned |
| Kernel shell | ☐ Planned |

---

## Notes

This roadmap is intentionally incremental.  
Each milestone is small, achievable, and builds toward a fully functional x86_64 kernel while keeping the project educational and approachable.

MIT licensed — contributions welcome.
