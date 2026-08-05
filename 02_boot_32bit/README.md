# 02_boot_32bit  
### 32‑bit Protected Mode Bootloader (x86)

This stage transitions the CPU from 16‑bit real mode into **32‑bit protected mode**, enabling flat addressing and modern instruction execution.  
It also demonstrates VGA text output in protected mode.

---

## 🧠 What This Stage Demonstrates

- Enabling the **A20 line**
- Building and loading a **GDT**
- Setting **CR0.PE** to enter protected mode
- Performing a far jump into 32‑bit code
- Setting up a 32‑bit stack
- Writing text directly to VGA memory (`0xB8000`)
- A clean protected‑mode execution environment

This is the same transition used by DOS extenders, early Windows versions, and modern OS bootloaders.

---

## 📂 Files

- `boot.asm` — real‑mode loader
- `stage2.asm` — protected‑mode entry and VGA output
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

Protected mode provides:

- 32‑bit registers
- Flat memory model via segmentation
- Ability to enable paging
- Foundation for entering long mode (64‑bit)

This stage is a stepping stone toward a modern OS kernel.

---

## 📌 Next Stage

Proceed to **03_boot_64bit** to enable paging, long mode, and execute 64‑bit code.
