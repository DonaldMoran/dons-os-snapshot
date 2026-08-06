# dons-os-snapshot

This repository is a **frozen snapshot** of the `dons-os-x86_64` project at milestone **v0.1.1-shell**.  
It exists solely as a **permanent branching point** for future operating system families.

## Snapshot Purpose

This repo captures the kernel exactly as it existed at the v0.1.1-shell milestone:
- Full 16 → 32 → 64-bit boot chain
- Verified long-mode entry
- Working PMM (bitmap physical memory allocator)
- IDT, PIC remap, PIT timer, IRQ0/IRQ1
- Buffered keyboard driver (shift, caps, backspace, repeat control)
- VGA text console with scrolling and cursor control
- Interactive command shell
- Clean project structure, Makefiles, and documentation

This snapshot is **immutable**.  
No new commits will be added, and no development will occur here.

## Why This Snapshot Exists

The main `dons-os-x86_64` repository will continue evolving into a full modern OS.  
This snapshot provides a stable, minimal, well‑defined kernel foundation for creating multiple OS families without polluting the main repo.

Future OS forks created from this snapshot include:
- `dons-dos` — minimal DOS‑like OS
- `dons-linux` — POSIX‑like OS with ELF loader and scheduler
- `dons-embedded` — tiny deterministic embedded kernel
- `dons-glibc` — full user-space capable OS with libc support

Each fork begins from this exact snapshot commit and evolves independently.

## Repository Policy

- Only the `main` branch is retained.
- All tags from the original project are preserved.
- No development will occur in this repository.
- This repo may be archived to prevent accidental changes.

## Upstream Project

Active development continues in the main repository:

`https://github.com/DonaldMoran/dons-os-x86_64`

This snapshot simply preserves the v0.1.1-shell milestone as a clean, stable branching point for future OS families.


## 📜 License

This project is licensed under the **MIT License**.  
Use freely, modify freely, credit appreciated.
