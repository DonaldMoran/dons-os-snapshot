# ROADMAP  
### dons‑os (x86_64) — Project Roadmap

This roadmap outlines the evolution of **dons‑os**, from the earliest boot stages to a functional interrupt‑driven kernel and beyond.

---

## 1. Boot Chain (Completed)

### ✔ 1.1 — 16‑bit Real Mode
- BIOS boot sector (`0x7C00`)
- INT 0x10 text output
- INT 0x13 disk loading
- Stage2 loader

### ✔ 1.2 — 32‑bit Protected Mode
- A20 enable
- GDT setup
- CR0.PE → protected mode
- VGA text output

### ✔ 1.3 — 64‑bit Long Mode
- PAE paging (PML4 → PDPT → PD → PT)
- IA32_EFER.LME set
- CR0.PG → paging enabled
- Far jump into 64‑bit code
- 64‑bit VGA text output

Boot chain is complete and stable.

---

## 2. Kernel Foundations (Completed)

### ✔ 2.1 — 64‑bit IDT + Exceptions
- IDT structure in long mode  
- ISR stubs in assembly  
- Basic exception handlers (Divide, Debug)

### ✔ 2.2 — PIC Remap
- Master → 0x20  
- Slave → 0x28  
- IRQs mapped to vectors 32–47

### ✔ 2.3 — PIT Timer (IRQ0)
- PIT programmed to 100 Hz  
- Global tick counter  
- On‑screen tick display

### ✔ 2.4 — Keyboard IRQ1
- IRQ1 handler  
- Raw scancode reader  
- Verified interrupt flow

### ✔ 2.5 — Physical Memory Manager
- Parse E820 map  
- Page allocator  
- Page allocation test

---

## 3. Core Kernel Features (Upcoming)

### ☐ 3.1 — ASCII Keyboard Driver
- Convert scancodes → ASCII  
- Handle Shift, Enter, Backspace

### ☐ 3.2 — Console Line Editor
- Input buffer  
- Cursor movement  
- Basic editing

### ☐ 3.3 — Kernel Shell
- Command parser  
- Built‑in commands:
  - `meminfo`
  - `uptime`
  - `help`
  - `clear`

### ☐ 3.4 — Higher‑Half Kernel
- Map kernel to `0xFFFFFFFF80000000`  
- Update linker script  
- Clean identity map

### ☐ 3.5 — Virtual Memory Manager
- Dynamic page mapping  
- Kernel heap (kmalloc)

### ☐ 3.6 — Scheduler Prototype
- Timer‑driven task switching  
- Cooperative or preemptive

---

## 4. User‑Facing Features

### ☐ 4.1 — Framebuffer Graphics
- Switch from VGA text mode  
- Draw pixels, shapes, text  
- Simple GUI experiments

### ☐ 4.2 — ELF Loader
- Load user‑space ELF binaries  
- Minimal syscall interface

### ☐ 4.3 — User‑Space Processes
- Paging isolation  
- Context switching  
- Process table

---

## 5. Development Tools

### ✔ QEMU Debug Mode
- `-d int,cpu_reset`  
- `-no-reboot -no-shutdown`

### ☐ GDB Remote Debugging
- Add `-s -S`  
- Document breakpoints

### ☐ Build Automation
- Top‑level Makefile (done)  
- Optional scripts directory

---

## Status Summary

| Stage | Status |
|-------|--------|
| Boot chain | ✔ Complete |
| Long‑mode kernel | ✔ Complete |
| Interrupts (IRQ0/IRQ1) | ✔ Complete |
| PMM | ✔ Complete |
| ASCII keyboard | ☐ Planned |
| Console | ☐ Planned |
| Shell | ☐ Planned |
| Higher‑half kernel | ☐ Planned |
| VMM | ☐ Planned |
| Scheduler | ☐ Planned |

---

## Notes

The roadmap is intentionally incremental.  
Each milestone builds toward a fully functional x86_64 kernel while keeping the project educational and approachable.

MIT licensed — contributions welcome.
