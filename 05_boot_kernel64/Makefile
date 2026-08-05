AS      := nasm

.PHONY: all clean run

all: boot.bin stage2.bin hdd.img

boot.bin: boot.asm
	$(AS) -f bin boot.asm -o boot.bin

stage2.bin: stage2.asm
	$(AS) -f bin stage2.asm -o stage2.bin

hdd.img: boot.bin stage2.bin ../04_kernel_64bit/kernel.bin
	rm -f hdd.img
	qemu-img create -f raw hdd.img 20M

	# LBA0: boot sector
	dd if=boot.bin of=hdd.img conv=notrunc

	# LBA1..40: stage2
	dd if=stage2.bin of=hdd.img bs=512 seek=1 conv=notrunc

	# LBA64+: kernel
	dd if=../04_kernel_64bit/kernel.bin of=hdd.img bs=512 seek=64 conv=notrunc

run:
	qemu-system-x86_64 -drive file=hdd.img,format=raw

clean:
	rm -f boot.bin stage2.bin hdd.img
