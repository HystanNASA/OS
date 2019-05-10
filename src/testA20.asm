; To test the A20 Line:
;   save 0x00 at 0000:0500
;   save 0xFF at FFFF:0510
;   if after that 0000:5000 stores 0xFF, the A20 Line is disabled
;
;
; Return 1 if the A20 Line is enabled, othewise, return 0
;
; ax stores the return value

testA20:
    pushf
    push ds
    push es
    push di
    push si

    cli

    xor ax, ax  ; ax = 0
    mov es, ax

    not ax      ; ax = 0xFFFF
    mov ds, ax

    mov di, 0x0500
    mov si, 0x0510

    mov al, byte [es:di]
    push ax     ; save byte at [0000:0x0500]

    mov al, byte [ds:si]
    push ax     ; save byte at [0xFFFF:0x0510]

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF

    cmp byte [es:di], 0xFF ; look at the result

    pop ax
    mov byte [ds:si], al ; restore value

    pop ax
    mov byte [es:di], al ; restore value

    mov ax, 0
    je check_a20__exit ; jump if it's enabled

    mov ax, 1

check_a20__exit:
    pop si
    pop di
    pop es
    pop ds
    popf

    ret
