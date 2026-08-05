This project documents the complete boot path of an x86_64 operating system, starting from the CPU’s reset state in 16‑bit real mode, progressing through 32‑bit protected mode, and finally entering 64‑bit long mode with paging enabled.

Each stage is implemented as a clean, minimal, self‑contained bootloader.
The goal is educational clarity: understand exactly how the processor transitions between modes and how a modern OS begins execution.
