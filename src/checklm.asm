checklm:
    pusha
    pushfd

    pop eax
    mov ecx, eax ; copy for comperig later on

    xor eax, 1 << 21 ; flip the ID bit

    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd

    xor eax, ecx
    jz .nolm

    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .nolm ; no long mode

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29 ; test the LM-bit which is bit 29
    jz .nolm ; no long mode

    popa
    ret

.nolm:
    popa
    mov si, NO_LONGMODE
    call print_str
    jmp $

NO_LONGMODE db "No Long Mode support.", 0x0a, 0x0d, 0
