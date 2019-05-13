checklm:
    pusha
    pushfd

    pop eax
    mov ecx, eax

    xor eax, 1 << 21

    push eax
    popfd

    pushfd
    pop eax

    xor eax, ecx
    jz .done

    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .done

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .done

    mov si, YES_LONGMODE
    call print_str

    popa
    ret

.done:
    popa
    mov si, NO_LONGMODE
    call print_str
    jmp $

NO_LONGMODE db "No Long Mode support.", 0x0a, 0x0d, 0
YES_LONGMODE db "Long Mode supported.", 0x0a, 0x0d, 0
