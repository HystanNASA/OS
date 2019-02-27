; move data to dx
printh:
    mov si, HEX_PATTERN + 2
    
    push cx
    push bx

    mov cl, 12

    loop_printh:

        mov bx, dx
        shr bx, cl
        and bx, 0x000F
        mov bx, [HEX_TABLE + bx]
        mov byte [si], bl

        inc si
        sub cl, 4

        cmp byte  [si], 0x0a
        jne loop_printh

    
    mov si, HEX_PATTERN
    call print_str

    pop bx
    pop cx

    ret

HEX_PATTERN db '0x****', 0x0a, 0x0d, 0
HEX_TABLE db '0123456789ABCDEF'