# Top‑level Makefile for dons‑os (x86_64)
# Builds each boot stage by delegating to its own Makefile

.PHONY: all clean \
	boot16 boot32 boot64 \
	run16 run32 run64

# Build everything
all: boot16 boot32 boot64

# Build individual stages
boot16:
	$(MAKE) -C 01_boot_16bit

boot32:
	$(MAKE) -C 02_boot_32bit

boot64:
	$(MAKE) -C 03_boot_64bit

# Run individual stages
run16:
	$(MAKE) -C 01_boot_16bit run

run32:
	$(MAKE) -C 02_boot_32bit run

run64:
	$(MAKE) -C 03_boot_64bit run

# Clean all stages
clean:
	$(MAKE) -C 01_boot_16bit clean
	$(MAKE) -C 02_boot_32bit clean
	$(MAKE) -C 03_boot_64bit clean
