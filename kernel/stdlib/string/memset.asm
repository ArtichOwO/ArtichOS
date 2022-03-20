BITS 16

GLOBAL memset

SECTION .text

memset:
    ; DI: Buffer offset
    ; ES: Buffer segment
    ; DL: Value
    ; CX: Size
    
    pusha

    memset.loop:

    mov [es:di], dl
    inc di

    loop memset.loop

    popa

    ret
