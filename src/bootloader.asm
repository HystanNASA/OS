org 0x7c00
bits 16

section .text
    global main

main:
    cli
    jmp 0x0000:ZeroSeg

ZeroSeg:
    xor ax, ax
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, main
    cld
    sti

    push ax
    xor ax, ax
    int 0x13
    pop ax

    mov al, 1
    mov cl, 2
    call read_disk

    call testA20
    call enableA20

    jmp secondSec

%include "readDisk.asm"
%include "printStr.asm"
%include "printh.asm"
%include "testA20.asm"
%include "enableA20.asm"

times 510 - ($-$$) db 0
dw 0xAA55

secondSec:
    call checklm

    cli
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd
    mov edi, 0x1000

    ;PML4T  -> 0x1000
    ;PDPT   -> 0x2000
    ;PDT    -> 0x3000
    ;PT     -> 0x4000

    mov dword [edi], 0x2003
    add edi, 0x1000
    mov dword [edi], 0x3003
    mov edi, 0x1000
    mov dword [edi], 0x4003

    mov dword ebx, 3
    mov ecx, 512

    .setEntry:
        mov dword [edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop .setEntry

    lgdt [GDT.Pointer]
    jmp GDT.Code:LongMode

%include "checklm.asm"
%include "gdt.asm"

bits 64
LongMode:

    VID_MEM equ 0xB8000

    mov edi, VID_MEM
    mov rax, 0x0F54
    mov ecx, 500
    rep stosq

    hlt

times 512 db 0
