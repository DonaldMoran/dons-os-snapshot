# dons‑os  
### Educational x86_64 Boot Chain Project (MIT Licensed)

This repository documents the complete boot path of an **x86_64 operating system**, starting from the CPU’s reset state in **16‑bit real mode**, progressing through **32‑bit protected mode**, and finally entering **64‑bit long mode** with paging enabled.

Each stage is implemented as a clean, minimal, self‑contained bootloader.  
The purpose is educational clarity: understand **exactly** how the processor transitions between modes and how a modern OS begins execution.

---

## 📁 Repository Structure

- **01_boot_16bit** — BIOS environment, boot sector, early text output  
- **02_boot_32bit** — A20 enable, GDT setup, protected mode, VGA text  
- **03_boot_64bit** — PAE paging, PML4/PDPT/PD/PT, IA32_EFER.LME, 64‑bit entry  

Each stage is fully bootable and isolated in its own directory.

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

This debug mode was instrumental in getting the 64‑bit stage working.

---

## 🎓 Purpose

This project is designed to be:

- **Readable** — minimal, clean assembly  
- **Incremental** — each stage builds on the last  
- **Accurate** — follows x86_64 architectural rules  
- **Practical** — boots in QEMU with simple commands  
- **Educational** — a reference for anyone learning OS development  

---

## 🌱 Next Steps

The 64‑bit boot chain in this repo serves as the foundation for a future development repository, where the actual kernel will grow:

- higher‑half kernel  
- linker script  
- C entry point  
- 64‑bit IDT + interrupts  
- keyboard input  
- framebuffer graphics  
- memory manager  
- scheduler  
- shell  

---

## 📜 License

This project is licensed under the **MIT License**.  
Use freely, modify freely, credit appreciated.
  

