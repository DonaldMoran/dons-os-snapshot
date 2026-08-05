[bits 16]
[org 0]

start:
    cli

    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; print 'S'
    mov ah, 0x0E
    mov al, 'S'
    int 0x10

hang:
    jmp hang

times 512-($-$$) db 0
