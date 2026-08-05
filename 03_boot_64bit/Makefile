all: boot.bin stage2.bin kernel.bin hdd.img

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

stage2.bin: stage2.asm
	nasm -f bin stage2.asm -o stage2.bin

kernel.bin: kernel.asm
	nasm -f bin kernel.asm -o kernel.bin

hdd.img: boot.bin stage2.bin kernel.bin
	rm -f hdd.img
	qemu-img create -f raw hdd.img 10M
	dd if=boot.bin    of=hdd.img conv=notrunc
	dd if=stage2.bin  of=hdd.img bs=512 seek=1  conv=notrunc
	dd if=kernel.bin  of=hdd.img bs=512 seek=64 conv=notrunc

run64: hdd.img
	qemu-system-x86_64 -drive file=hdd.img,format=raw

clean:
	rm -f boot.bin stage2.bin kernel.bin hdd.img
