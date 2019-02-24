; move the number of sectors to read to al
; move the sector number to cl
read_disk:   
    pusha

    mov ah, 0x02
    mov dl, 0x80 ; reading from disk
    mov ch, 0
    mov dh, 0

    push bx
    mov bx, 0
    mov es, bx
    pop bx
    mov bx, 0x7c00 + 512

    int 0x13

    jc disk_error
    popa
    ret

    disk_error:
        mov si, DISK_ERROR_MSG
        call print_str
        ret

DISK_ERROR_MSG db "ERROR: Could not read...", 0
