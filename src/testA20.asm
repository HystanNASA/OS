testA20:
    pusha

    mov ax, [0x7DFE]
    mov dx, ax
    call printh

    push bx
    mov bx, 0xFFFF
    mov es, bx
    pop bx

    mov bx, 0x7E0E

    mov dx, [es:bx]
    call printh

    cmp ax, dx
    je .cont

    mov dx, 0x2222
    call printh

    popa
    mov ax, 1
    ret

    .cont:
        mov ax, [0x7DFF]
        mov dx, ax
        call printh

        push bx
        mov bx, 0xFFFF
        mov es, bx
        pop bx

        mov bx, 0x7E0F
        
        mov dx, [es:bx]
        call printh

        cmp ax, dx
        je .exit


    popa
    mov ax, 1
    ret

    .exit:
    popa
    xor ax, ax
    ret