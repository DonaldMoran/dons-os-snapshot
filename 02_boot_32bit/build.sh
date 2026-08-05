rm -f boot.bin stage2.bin hdd.img

nasm -f bin boot.asm   -o boot.bin
nasm -f bin stage2.asm -o stage2.bin

qemu-img create -f raw hdd.img 10M

dd if=boot.bin   of=hdd.img conv=notrunc
dd if=stage2.bin of=hdd.img bs=512 seek=1 conv=notrunc

qemu-system-i386 -drive file=hdd.img,format=raw,if=ide -boot c
