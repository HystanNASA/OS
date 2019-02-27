; move the string to si before call print_str
print_str:
    pusha

    mov cl, 10

    str_loop:
        mov al, [si]
        cmp al, 0
        je return_from_print_str
        
        mov ah, 0xE
        int 0x10

        inc si
        jmp str_loop

    return_from_print_str:
        popa
        ret

TEST_STR db "We're in the second sector", 0
