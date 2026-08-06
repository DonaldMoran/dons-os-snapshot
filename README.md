# dons‑os  
### Educational x86_64 Boot Chain + 64‑bit Interrupt‑Driven Kernel (MIT Licensed)

**dons‑os** is a fully custom x86_64 operating system built from scratch, starting at the CPU’s reset vector in **16‑bit real mode**, progressing through **32‑bit protected mode**, entering **64‑bit long mode**, and finally executing a **C‑based 64‑bit kernel** with working interrupts, timer, and keyboard input.

The project emphasizes clarity, correctness, and educational value.  
Each stage is isolated, minimal, and fully bootable.

---

## 📁 Repository Structure

### Bootloaders
- **01_boot_16bit** — BIOS boot sector, INT 0x10 text, INT 0x13 disk loading  
- **02_boot_32bit** — A20 enable, GDT, protected mode, VGA text  
- **03_boot_64bit** — PAE paging, PML4/PDPT/PD/PT, IA32_EFER.LME, long‑mode entry  

### Kernel Development
- **04_kernel_64bit** — Standalone 64‑bit kernel (ELF → flat), IDT, ISR stubs, PIC remap, PIT timer, IRQ0 tick, IRQ1 keyboard, PMM, VGA  
- **05_boot_kernel64** — Full boot chain: stage2 loads kernel, enters long mode, jumps to `_start`

The top‑level Makefile builds and runs all components.

---

## 🚀 Building & Running

### Build everything
```bash
make all
```

### Run individual boot demos
```
make run16
make run32
make run64
```

### Build the 64‑bit kernel
```
make kernel64
```

### Build + run the full long‑mode OS
```
make bootkernel64
make runkernel64
```

This boots:

1. BIOS → stage1  
2. stage1 loads stage2  
3. stage2 builds page tables  
4. stage2 enters long mode  
5. stage2 jumps to kernel at 0x00100000  
6. kernel executes `_start` → `kmain`  
7. kernel prints to VGA text mode
8. kernel initializes IDT, PIC, PIT
9. kernel prints memory map, allocates pages, and responds to keyboard input

---

## 🐞 Debug Mode (QEMU)

Debugging early boot code is notoriously difficult.  
QEMU’s built‑in logging makes it dramatically easier to diagnose faults, paging issues, and incorrect mode transitions.

Run **any** boot stage in debug mode using:

```
qemu-system-x86_64 \
  -drive file=hdd.img,format=raw \
  -d int,cpu_reset \
  -no-reboot \
  -no-shutdown
```

### 🔍 What this enables

- **`-d int`** — logs all CPU interrupts (hardware + software)  
- **`-d cpu_reset`** — logs CPU resets (critical for diagnosing triple faults)  
- **`-no-reboot`** — prevents QEMU from instantly restarting on a fault  
- **`-no-shutdown`** — keeps QEMU open so you can read the debug output  

### 🧩 Useful for diagnosing

- invalid far jumps  
- incorrect segment selectors  
- paging faults  
- triple faults  
- CR0/CR4/EFER misconfiguration  
- long‑mode entry failures  

This debug mode was instrumental in getting the 64‑bit kernel working.

---

## 🎓 Purpose

This project is designed to be:

- **Readable** — minimal, clean assembly and C  
- **Incremental** — each stage builds on the last  
- **Accurate** — follows x86_64 architectural rules  
- **Practical** — boots in QEMU with simple commands  
- **Educational** — a reference for anyone learning OS development  

---

## 🌱 Current Milestone: Long‑Mode Kernel Boot

The `dev` branch contains the first successful:

- ELF → flat binary kernel pipeline  
- long‑mode entry via stage2  
- kernel relocation to 0x00100000  
- execution of `_start` and `kmain`  
- IDT + exception handlers
- PIC remap (IRQs 32–47)
- PIT timer @ 100 Hz (IRQ0)
- Global tick counter
- Keyboard IRQ1 scancode reader
- VGA text output
- Physical memory map (E820)
- Physical memory manager (page allocator)
- Stable interrupt‑driven execution 

Tag: **v0.0.1-longmode**
Tag: v0.0.2-interrupts

## 🏷️ Commit Milestone: Interrupt‑Driven Kernel

This commit marks the first fully interactive 64‑bit kernel in the project’s history.

Included in this milestone:

- 64‑bit IDT + exception handlers  
- PIC remap (IRQs 32–47)  
- PIT timer @ 100 Hz (IRQ0)  
- Global kernel tick counter  
- Keyboard IRQ1 scancode reader  
- VGA text output  
- E820 physical memory map parsing  
- Physical Memory Manager (page allocator)  
- Stable interrupt‑driven execution  
- Updated README.md and ROADMAP.md to reflect new kernel capabilities

Tag: **v0.0.2-interrupts**

## 🏷️ Commit Milestone: Interrupt‑Driven Kernel (v0.0.2-interrupts)

This commit introduces the first fully interactive 64‑bit kernel:

- 64‑bit IDT + exception handlers  
- PIC remap (IRQs 32–47)  
- PIT timer @ 100 Hz (IRQ0)  
- Global kernel tick counter  
- Keyboard IRQ1 scancode reader  
- VGA text output  
- E820 physical memory map parsing  
- Physical Memory Manager (page allocator)  
- Stable interrupt‑driven execution  
- Updated README.md and ROADMAP.md to reflect new kernel capabilities

Tag: **v0.0.2-interrupts**

---

## 🌱 Next Steps

Planned kernel features:

- ASCII keyboard translation
- Console line editor
- Kernel shell
- Higher‑half kernel
- Virtual memory manager
- Scheduler
- Framebuffer graphics
- ELF loader
- User‑space processes

---

## 📜 License

This project is licensed under the **MIT License**.  
Use freely, modify freely, credit appreciated.
