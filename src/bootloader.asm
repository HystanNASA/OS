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
    mov dx, ax
    call printh

    cli
    hlt

%include "readDisk.asm"
%include "printStr.asm"
%include "printh.asm"
%include "testA20.asm"

times 510 - ($-$$) db 0
dw 0xAA55

hlt