; al is a number of sectors to read
; cl is a sector
; es:bx is a buffer adress pointer
read_disk:
    pusha

    mov ah, 0x02 ; read sector from disk
    mov dl, 0x80 ; read from disk
    mov ch, 0    ; cylinder
    mov dh, 0    ; head

    int 0x13

    jc disk_error
    popa
    ret

    disk_error:
        mov si, DISK_ERROR_MSG
        call print_str
        ret

DISK_ERROR_MSG db "ERROR: Could not read...", 0
