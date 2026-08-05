[bits 64]
[section .text]
[global _start]

_start:
    ; simple stack
    mov rsp, 0x80000

    ; clear RAX so kernel doesn't inherit 0x80000011
    xor rax, rax

    extern kmain
    call kmain

hang:
    jmp hang
