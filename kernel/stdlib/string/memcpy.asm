BITS 16

GLOBAL memcpy

SECTION .text

memcpy:
    ; DI: Destination offset
    ; AX: Destination segment
    ; SI: Source offset
    ; BX: Source segment
    ; CX: Size
    
    pusha

    memcpy.loop:

    push bx
    pop es
    mov dl, [es:si]

    push ax
    pop es
    mov [es:di], dl

    inc si
    inc di

    loop memcpy.loop

    popa

    ret
