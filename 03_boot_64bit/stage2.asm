; stage2.asm - Clean final version
[bits 16]
[org 0]

start:
    cli

    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; enable A20
    in  al, 0x92
    or  al, 00000010b
    out 0x92, al

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enter protected mode
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp 0x08:pm_entry

[bits 32]
pm_entry:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    ; Enable PAE
    mov eax, cr4
    or  eax, 1 << 5
    mov cr4, eax

    ; Set up minimal paging
    mov eax, pml4 + 0x10000
    mov cr3, eax

    ; Enable Long Mode
    mov ecx, 0xC0000080
    rdmsr
    or  eax, 1 << 8
    wrmsr

    ; Enable Paging
    mov eax, cr0
    or  eax, 0x80000000
    mov cr0, eax

    ; Jump to 64-bit
    push dword 0x18
    push dword long_mode_entry + 0x10000
    retf

[bits 64]
long_mode_entry:
    mov rsp, 0x80000

    ; clear screen
    mov rdi, 0xB8000
    mov rcx, 80*25
    mov ax, 0x0720
    rep stosw

    ; write "HELLO FROM 64BIT"
    mov rdi, 0xB8760

    mov ax, 0x0748            ; 'H'
    stosw
    mov ax, 0x0745            ; 'E'
    stosw
    mov ax, 0x074C            ; 'L'
    stosw
    mov ax, 0x074C            ; 'L'
    stosw
    mov ax, 0x074F            ; 'O'
    stosw
    mov ax, 0x0720            ; ' '
    stosw
    mov ax, 0x0746            ; 'F'
    stosw
    mov ax, 0x0752            ; 'R'
    stosw
    mov ax, 0x074F            ; 'O'
    stosw
    mov ax, 0x074D            ; 'M'
    stosw
    mov ax, 0x0720            ; ' '
    stosw
    mov ax, 0x0736            ; '6'
    stosw
    mov ax, 0x0734            ; '4'
    stosw
    mov ax, 0x0742            ; 'B'
    stosw
    mov ax, 0x0749            ; 'I'
    stosw
    mov ax, 0x0754            ; 'T'
    stosw

hang64:
    jmp hang64

; GDT
gdt_start:
    dq 0x0000000000000000              ; null
    dq 0x00CF9A010000FFFF              ; 32-bit code (base 0x00010000)
    dq 0x00CF92000000FFFF              ; 32-bit data (base 0)
    dq 0x00AF9A000000FFFF              ; 64-bit code (base 0)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start + 0x10000

; Paging structures
align 4096
pml4:
    dq pdpt + 0x10000 + 0x003

align 4096
pdpt:
    dq pd + 0x10000 + 0x003

align 4096
pd:
    dq pt + 0x10000 + 0x003
    times 511 dq 0

align 4096
pt:
    %assign i 0
    %rep 512
        dq (i*4096) + 0x003
        %assign i i+1
    %endrep
