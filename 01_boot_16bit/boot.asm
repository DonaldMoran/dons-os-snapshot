[org 0x7C00]
[bits 16]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; print 'B' so we know we’re in the boot sector
    mov ah, 0x0E
    mov al, 'B'
    int 0x10

    ; use BIOS boot drive in DL (like MikeOS does)
    ; (DL already contains it, so we don’t touch it)

    ; load 1 sector from CHS 0/0/2 into 0x1000:0000
    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    mov ah, 0x02      ; read sectors
    mov al, 0x01      ; 1 sector
    mov ch, 0x00      ; cylinder 0
    mov cl, 0x02      ; sector 2
    mov dh, 0x00      ; head 0
    int 0x13
    jc disk_error

    ; if we get here, read succeeded — print 'R' like MikeOS would
    mov ah, 0x0E
    mov al, 'R'
    int 0x10

    jmp 0x1000:0      ; jump to stage2

disk_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10
hang:
    jmp hang

times 510-($-$$) db 0
dw 0xAA55
