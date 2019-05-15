bits 16
org 0x7C00

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

    ; reset disk system
    push ax
    xor ax, ax
    int 0x13
    pop ax

    ; read 2nd bootloader
    mov al, 1
    mov cl, 2
    mov bx, 0
    mov es, bx
    mov bx, 0x7C00 + 512
    call read_disk

    call testA20
    call enableA20

    jmp secondSec

%include "readDisk.asm"
%include "printStr.asm"
%include "printh.asm"

times 510 - ($-$$) db 0
dw 0xAA55

secondSec:
    call checklm

    ; disable the old paging
    mov eax, cr0
    and eax, 01111111111111111111111111111111b
    mov cr0, eax

    ; set up paging
    cli
    mov edi, 0x1000 ; set the dest index
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd
    mov edi, cr3

    ;----------------;
    ;PML4T  -> 0x1000;
    ;PDPT   -> 0x2000;
    ;PDT    -> 0x3000;
    ;PT     -> 0x4000;
    ;----------------;

    ; pages are present and they're readable and writable because of a three
    mov dword [edi], 0x2003
    add edi, 0x1000
    mov dword [edi], 0x3003
    add edi, 0x1000
    mov dword [edi], 0x4003
    add edi, 0x1000

    mov ebx, 0x00000003
    mov ecx, 512

    .setEntry:
        mov dword [edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop .setEntry

    mov eax, cr4
    or eax, 1 << 5 ; set the PAE-bit, which is the 6th bit (bit 5)
    mov cr4, eax
    sti
    ; paging is set up

    ; set the long mode
    mov ecx, 0xC0000080
    rdmsr           ; read from the model-specific register
    or eax, 1 << 8  ; set the LM-bit which is the 9th bit (8 bit)
    wrmsr           ; write to  the model-specific register

    ; enable paging and protected mode
    mov eax, cr0
    or eax, 1 << 31 ; set the LM-bit which is the 32nd bit (31 bit)
    mov cr0, eax

    lgdt [GDT64.Pointer]    ; load the 64-bit gdt
    jmp GDT64.Code:LongMode ; set the code segment and enter 64-bit long mode

%include "testA20.asm"
%include "enableA20.asm"
%include "checklm.asm"
%include "gdt64.asm"

bits 64
LongMode:
    cli                           ; Clear the interrupt flag.
    mov ax, GDT64.Data            ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.
    mov edi, 0xB8000              ; Set the destination index to 0xB8000.
    mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20.
    mov ecx, 500                  ; Set the C-register to 500.
    rep stosq                     ; Clear the screen.
    hlt

times 512 db 0
