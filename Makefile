# Top-level Makefile for dons-os-x86_64

.PHONY: all clean \
	boot16 run16 \
	boot32 run32 \
	boot64 run64 \
	kernel64 \
	bootkernel64 runkernel64

# -------------------------
# Default: build everything
# -------------------------
all: boot16 boot32 boot64 kernel64 bootkernel64

# -------------------------
# 16-bit boot demo (01)
# -------------------------
boot16:
	$(MAKE) -C 01_boot_16bit

run16:
	$(MAKE) -C 01_boot_16bit run

# -------------------------
# 32-bit boot demo (02)
# -------------------------
boot32:
	$(MAKE) -C 02_boot_32bit

run32:
	$(MAKE) -C 02_boot_32bit run

# -------------------------
# 64-bit boot demo (03)
# -------------------------
boot64:
	$(MAKE) -C 03_boot_64bit

run64:
	$(MAKE) -C 03_boot_64bit run64

# -------------------------
# 64-bit kernel build only (04)
# -------------------------
kernel64:
	$(MAKE) -C 04_kernel_64bit

# -------------------------
# Full 64-bit boot + kernel pipeline (05)
# -------------------------
bootkernel64:
	$(MAKE) -C 05_boot_kernel64

runkernel64:
	$(MAKE) -C 05_boot_kernel64 run

# -------------------------
# Clean everything
# -------------------------
clean:
	$(MAKE) -C 01_boot_16bit clean
	$(MAKE) -C 02_boot_32bit clean
	$(MAKE) -C 03_boot_64bit clean
	$(MAKE) -C 04_kernel_64bit clean
	$(MAKE) -C 05_boot_kernel64 clean
