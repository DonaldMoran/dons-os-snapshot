# 03_boot_64bit  
### 64‑bit Long Mode Bootloader (x86_64)

This stage transitions the CPU from 32‑bit protected mode into **64‑bit long mode**, the execution environment used by all modern x86_64 operating systems.

It includes a minimal identity‑mapped paging setup and a clean 64‑bit entry point.

---

## 🧠 What This Stage Demonstrates

- Enabling **PAE** (`CR4.PAE`)
- Building minimal paging structures:
  - PML4
  - PDPT
  - Page Directory
  - Page Table
- Identity‑mapping the first 2 MB of memory
- Setting **IA32_EFER.LME** to enable long mode
- Enabling paging (`CR0.PG`)
- Far‑jumping into a 64‑bit code segment
- Executing 64‑bit instructions
- Clearing the screen and printing text in long mode

This is the exact boot path used by Linux, BSD, Windows, and other modern kernels.

---

## 📂 Files

- `boot.asm` — real‑mode loader
- `stage2.asm` — protected‑mode + long‑mode transition
- `Makefile` — builds and runs the boot chain

---

## 🚀 Build & Run

```bash
make
make run
```

Requires:

- NASM
- QEMU
- GNU Make

---

## 🎓 Educational Notes

Long mode provides:

- 64‑bit registers
- 64‑bit virtual addressing
- Paging required (no segmentation)
- Foundation for higher‑half kernels
- Ability to write modern OS kernels in C/C++

This stage is the final architectural transition before building a full kernel.

---

## 📌 Next Steps

Use this boot chain as the foundation for a new repository:

- Higher‑half kernel (`0xFFFFFFFF80000000`)
- Linker script
- C entry point
- 64‑bit IDT + interrupts
- Keyboard input
- Framebuffer graphics
- Memory manager
- Scheduler
- Shell

This is where the real OS begins.
