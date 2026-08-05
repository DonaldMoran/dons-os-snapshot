# Top-level Makefile for dons-os-x86_64

# -------------------------
# Toolchain
# -------------------------
CC      := clang
LD      := ld.lld
AS      := nasm

CFLAGS  := -target x86_64-unknown-elf -ffreestanding -O2 -Wall -Wextra
LDFLAGS := -nostdlib

.PHONY: all clean boot16 run16 boot32 run32 boot64 run64 kernel kernel64 run_kernel64 bootkernel64 runkernel64

# -------------------------
# Default: build all boot demos
# -------------------------
all: boot16 boot32 boot64

# -------------------------
# 16-bit boot demo
# -------------------------
boot16:
	$(MAKE) -C 01_boot_16bit

run16:
	$(MAKE) -C 01_boot_16bit run

# -------------------------
# 32-bit boot demo
# -------------------------
boot32:
	$(MAKE) -C 02_boot_32bit

run32:
	$(MAKE) -C 02_boot_32bit run

# -------------------------
# 64-bit boot demo
# -------------------------
boot64:
	$(MAKE) -C 03_boot_64bit

run64:
	$(MAKE) -C 03_boot_64bit run64


bootkernel64:
	$(MAKE) -C 05_boot_kernel64

runkernel64:
	$(MAKE) -C 05_boot_kernel64 run

kernel64:
	$(MAKE) -C 04_kernel_64bit

run_kernel64:
	$(MAKE) -C 04_kernel_64bit run

# -------------------------
# Clean everything
# -------------------------
clean:
	$(MAKE) -C 01_boot_16bit clean
	$(MAKE) -C 02_boot_32bit clean
	$(MAKE) -C 03_boot_64bit clean
