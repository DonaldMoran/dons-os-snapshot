# dons‑os  
### Educational x86_64 Boot Chain + 64‑bit Kernel Project (MIT Licensed)

This repository documents the complete boot path of an **x86_64 operating system**, starting from the CPU’s reset state in **16‑bit real mode**, progressing through **32‑bit protected mode**, entering **64‑bit long mode**, and finally loading and executing a **C‑based 64‑bit kernel**.

Each stage is implemented as a clean, minimal, self‑contained bootloader or kernel module.  
The purpose is educational clarity: understand **exactly** how the processor transitions between modes and how a modern OS begins execution.

---

## 📁 Repository Structure

### Bootloaders
- **01_boot_16bit** — BIOS environment, boot sector, early text output  
- **02_boot_32bit** — A20 enable, GDT setup, protected mode, VGA text  
- **03_boot_64bit** — PAE paging, PML4/PDPT/PD/PT, IA32_EFER.LME, long‑mode entry  

### Kernel Development
- **04_kernel_64bit** — Standalone 64‑bit kernel build (ELF → flat binary), `_start`, `kmain`, VGA text  
- **05_boot_kernel64** — Full boot pipeline: stage2 loads kernel, enters long mode, jumps to `_start`

Each stage is fully bootable and isolated in its own directory.  
The top‑level Makefile builds and runs all components.

---

## 🚀 Building & Running

### Build everything
```
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
- VGA text output from 64‑bit C code  
- stable RIP flow with no triple faults  

Tag: **v0.0.1-longmode**

---

## 🌱 Next Steps

Planned kernel features:

- higher‑half kernel  
- linker script improvements  
- 64‑bit IDT + interrupts  
- keyboard input  
- framebuffer graphics  
- physical memory map (E820)  
- memory manager  
- scheduler  
- shell  

---

## 📜 License

This project is licensed under the **MIT License**.  
Use freely, modify freely, credit appreciated.
