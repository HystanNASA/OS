GDT64:
  .Null: equ $ - GDT64
    dw 0xFFFF      ; limit (low)
    dw 0           ; base (low)
    db 0           ; base (middle)
    db 0           ; access
    db 1           ; granularity
    db 0           ; base (high)
  .Code: equ $ - GDT64
    dw 0           ; limit (low)
    dw 0           ; base (low)
    db 0           ; base (middle)
    db 10011010b   ; access (exec/read)
    db 10101111b   ; granularity, 64 bits flag, limit19:16
    db 0           ; base (highs)
  .Data: equ $ - GDT64
    dw 0           ; limit (low)
    dw 0           ; base (low)
    db 0           ; base (middle)
    db 10010010b   ; access (read/write)
    db 00000000b   ; granularity
    db 0           ; base (high)
  .Pointer:
    dw $ - GDT64 - 1 ; limit
    dq GDT64         ; base
