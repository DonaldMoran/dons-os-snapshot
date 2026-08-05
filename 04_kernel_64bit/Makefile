CC      := clang
LD      := ld.lld
AS      := nasm
OBJCOPY := llvm-objcopy   # or 'objcopy' if you prefer GNU

CFLAGS  := -target x86_64-unknown-elf -ffreestanding -O2 -Wall -Wextra -mcmodel=small -fno-pic
LDFLAGS := -nostdlib

.PHONY: all clean

all: kernel.bin

kernel.elf: entry.o kmain.o
	$(LD) $(LDFLAGS) -T linker.ld -o kernel.elf entry.o kmain.o

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary kernel.elf kernel.bin

entry.o: entry.asm
	$(AS) -f elf64 entry.asm -o entry.o

kmain.o: kmain.c
	$(CC) $(CFLAGS) -c kmain.c -o kmain.o

clean:
	rm -f *.o kernel.elf kernel.bin
