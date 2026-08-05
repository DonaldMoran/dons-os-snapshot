[bits 16]
[org 0]

start:
    cli

    ; we are at 0x1000:0000
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; print 'S'
    mov ah, 0x0E
    mov al, 'S'
    int 0x10

    ; enable A20 via port 0x92
    in  al, 0x92
    or  al, 00000010b
    out 0x92, al

    ; load GDT (base = gdt_start + 0x10000)
    lgdt [gdt_descriptor]

    ; enter protected mode
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp 0x08:pm_entry

; ---------------------------
; 32-bit code
; ---------------------------

[bits 32]
pm_entry:
    ; set data segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; simple 32-bit stack
    mov esp, 0x90000

    ; clear screen: 80x25, attribute 0x07, space
    mov edi, 0xB8000
    mov ecx, 80*25
    mov ax, 0x0720
    rep stosw

    ; write "HELLO FROM PM" at row 12, col 30
    ; row 12 -> 12*160 = 1920, col 30 -> 30*2 = 60
    ; base = 0xB8000 + 1920 + 60 = 0xB8760
    mov edi, 0xB8760

    mov ax, 0x0748        ; 'H'
    stosw
    mov ax, 0x0745        ; 'E'
    stosw
    mov ax, 0x074C        ; 'L'
    stosw
    mov ax, 0x074C        ; 'L'
    stosw
    mov ax, 0x074F        ; 'O'
    stosw
    mov ax, 0x0720        ; ' '
    stosw
    mov ax, 0x0746        ; 'F'
    stosw
    mov ax, 0x0752        ; 'R'
    stosw
    mov ax, 0x074F        ; 'O'
    stosw
    mov ax, 0x074D        ; 'M'
    stosw
    mov ax, 0x0720        ; ' '
    stosw
    mov ax, 0x0750        ; 'P'
    stosw
    mov ax, 0x074D        ; 'M'
    stosw

hang:
    jmp hang

; ---------------------------
; GDT
; ---------------------------

[bits 16]
gdt_start:
    dq 0x0000000000000000              ; null
    dq 0x00CF9A010000FFFF              ; code: base = 0x00010000
    dq 0x00CF92000000FFFF              ; data: base = 0x00000000
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start + 0x10000             ; GDT base at 0x00010000 + offset of gdt_start

times 512-($-$$) db 0
