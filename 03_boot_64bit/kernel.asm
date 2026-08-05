; kernel.asm — simple 64-bit "kernel" that writes a message and hangs
[bits 64]
[org 0x00100000]

kernel_entry:
    mov rdi, 0xB8000
    mov rcx, 80*25
    mov ax, 0x0720
    rep stosw

    mov rdi, 0xB8760

    mov ax, 0x074B    ; 'K'
    stosw
    mov ax, 0x0745    ; 'E'
    stosw
    mov ax, 0x0752    ; 'R'
    stosw
    mov ax, 0x0753    ; 'N'
    stosw
    mov ax, 0x0745    ; 'E'
    stosw
    mov ax, 0x0752    ; 'R'
    stosw

hang:
    jmp hang
