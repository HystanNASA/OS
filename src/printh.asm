; move data to dx
printh:
    mov si, HEX_PATTERN

    push al
    push cl

    mov al, [HEX_PATTERN + 2]
    mov cl, 12

    printh_loop:
        mov bx, dx
        shr bx, cl
        and bx, 0x000F
        mov  bx, [bx + HEX_TABLE]
        mov [al], bl

        inc al
        sub cl, 4

        

    call print_str
    ret

HEX_PATTERN db '0x****', 0x0a, 0x0d, 0
HEX_TABLE db '0123456789ABCDEF'