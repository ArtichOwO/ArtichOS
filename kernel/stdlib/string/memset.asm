BITS 16

GLOBAL memset

SECTION .text

memset:
    ; DI: Buffer offset
    ; ES: Buffer segment
    ; DL: Value
    ; CX: Size
    ; Ret: Buffer offset
    
    pusha

    memset.loop:

    mov [es:di], dl
    inc di

    loop memset.loop

    popa

    ret
