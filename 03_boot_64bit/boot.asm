; boot.asm
[bits 16]
[org 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; print 'B'
    mov ah, 0x0E
    mov al, 'B'
    int 0x10

    ; load stage2 to 0x1000:0000
    mov ax, 0x1000
    mov es, ax
    mov bx, 0x0000

    ; Read 64 sectors (32KB) - stage2 is about 20KB
    mov ah, 0x02
    mov al, 64            ; Read more sectors
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    int 0x13
    jc disk_error

    ; print 'R'
    mov ah, 0x0E
    mov al, 'R'
    int 0x10

    jmp 0x1000:0x0000

disk_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xAA55
