[bits 16]
[org 0x10000]

start:
    cli

    ; ----------------------------------------------------
    ; Breadcrumbs in real mode only
    ; ----------------------------------------------------
    mov ax, 0xB800
    mov ds, ax
    mov byte [0], '1'      ; stage2 start
    mov byte [1], 0x07

    mov byte [2], 'R'      ; stage2 running
    mov byte [3], 0x07

    ; ----------------------------------------------------
    ; Set up segment registers (real mode)
    ; ----------------------------------------------------
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; ----------------------------------------------------
    ; Enable A20
    ; ----------------------------------------------------
    in  al, 0x92
    or  al, 00000010b
    out 0x92, al

    ; ----------------------------------------------------
    ; Load kernel (64 sectors from LBA 64 → 0x8000:0000)
    ; ----------------------------------------------------
    mov si, dap_kernel
    mov dl, 0x80
    mov ah, 0x42
    int 0x13

    ; ----------------------------------------------------
    ; Load GDT (still real mode)
    ; ----------------------------------------------------
    lgdt [gdt_descriptor]

    ; ----------------------------------------------------
    ; Enter protected mode
    ; ----------------------------------------------------
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    ; *** IMPORTANT: use 32‑bit far jump ***
    jmp dword 0x08:pm_entry

; --------------------------------------------------------
; Disk Address Packet for kernel
; --------------------------------------------------------
dap_kernel:
    db 16
    db 0
    dw 64          ; sector count
    dw 0x0000      ; offset
    dw 0x8000      ; segment -> 0x00080000
    dq 64          ; LBA

; --------------------------------------------------------
; Protected mode entry (32-bit)
; --------------------------------------------------------
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

    ; Load PML4 (physical address)
    mov eax, pml4
    mov cr3, eax

    ; Enable long mode
    mov ecx, 0xC0000080
    rdmsr
    or  eax, 1 << 8
    wrmsr

    ; Enable paging
    mov eax, cr0
    or  eax, 0x80000000
    mov cr0, eax

    ; Far jump to 64‑bit mode
    push dword 0x18
    push dword long_mode_entry
    retf

; --------------------------------------------------------
; Long mode entry
; --------------------------------------------------------
[bits 64]
long_mode_entry:
    mov rsp, 0x80000

    ; clear registers inherited from stage2
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    ; BIOS loaded kernel at 0x00080000
    mov rsi, 0x00080000

    ; we want it at 0x00100000
    mov rdi, 0x00100000

    ; copy 8 KB (more than enough for your kernel)
    mov rcx, 1024
    rep movsq

    ; jump to kernel entry
    jmp 0x00100000

; --------------------------------------------------------
; GDT
; --------------------------------------------------------
gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF   ; 0x08: 32‑bit code
    dq 0x00CF92000000FFFF   ; 0x10: 32‑bit data
    dq 0x00AF9A000000FFFF   ; 0x18: 64‑bit code
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start            ; org 0x10000 → physical matches linear

; --------------------------------------------------------
; Paging structures (identity map first 2 MiB)
; --------------------------------------------------------
align 4096
pml4:
    dq pdpt + 3

align 4096
pdpt:
    dq pd + 3

align 4096
pd:
    dq pt + 3
    times 511 dq 0

align 4096
pt:
    %assign i 0
    %rep 512
        dq (i * 4096) + 3
        %assign i i+1
    %endrep
