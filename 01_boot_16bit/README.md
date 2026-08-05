# 01_boot_16bit  
### 16‑bit Real Mode Boot Sector (x86)

This stage contains a minimal 16‑bit bootloader that runs directly after the CPU resets and BIOS loads the boot sector to `0x7C00`.  
It demonstrates how the earliest part of an operating system begins execution on x86 hardware.

---

## 🧠 What This Stage Demonstrates

- CPU startup in **real mode**
- BIOS text output using `INT 0x10`
- Disk reading using `INT 0x13`
- Loading the next stage into memory
- Jumping to a new segment:offset
- A fully bootable 512‑byte boot sector with `0xAA55` signature

This is the foundation of all x86 operating systems.

---

## 📂 Files

- `boot.asm` — 16‑bit boot sector
- `Makefile` — builds `boot.bin` and runs it in QEMU

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

Real mode provides:

- 20‑bit addressing (1 MB space)
- BIOS interrupts
- Segmented memory model
- No protection, no paging

This stage is intentionally simple and prepares the system to load more advanced boot code.

---

## 📌 Next Stage

Proceed to **02_boot_32bit** to enter protected mode and begin executing 32‑bit code.
