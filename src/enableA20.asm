enableA20:
    pusha

;BIOS
    mov ax, 0x2401
    int 0x15

    call testA20
    cmp ax, 1
    je .done

;Keyboard
    cli

    call waitC
    mov al, 0xAD
    out 0x64, al

    call waitC
    mov al, 0xD0
    out 0x64, al

    call waitD
    in al, 0x60
    push ax

    call waitC
    mov al, 0xD1
    out 0x64, al

    call waitC
    pop ax
    or al, 2
    out 0x60, al

    call waitC
    mov al, 0xAE
    out 0x64, al

    call waitC

    sti

    call testA20
    cmp ax, 1
    je .done

;FastA20
    in al, 0x92
    or al, 2
    out 0x92, al

    call testA20
    cmp al, 1
    je .done

    mov si, NO_A20
    call print_str

    jmp $

.done:
    popa
    mov ax, 1
    ret

waitC:
    in al, 0x64
    test al, 2
    jnz waitC
    ret

waitD:
    in al, 0x64
    test al, 1
    jz waitD
    ret

NO_A20 db "No A20 line", 0x0a, 0x0d, 0
