NASM = nasm

all: hdd.img

boot.bin: boot.asm
    $(NASM) -f bin boot.asm -o boot.bin

stage2.bin: stage2.asm
    $(NASM) -f bin stage2.asm -o stage2.bin

hdd.img: boot.bin stage2.bin
    rm -f hdd.img
    qemu-img create -f raw hdd.img 10M
    dd if=boot.bin   of=hdd.img conv=notrunc
    dd if=stage2.bin of=hdd.img bs=512 seek=1 conv=notrunc

run: hdd.img
    qemu-system-i386 -drive file=hdd.img,format=raw,if=ide -boot c

clean:
    rm -f boot.bin stage2.bin hdd.img
