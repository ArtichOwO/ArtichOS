BITS 16

GLOBAL strlen

SECTION .text

strlen:
    ; ES -> String segment
    ; SI -> String offset
    ; Ret: String size
    
    xor bx, bx

    strlen.check:
    cmp byte [es:si+bx], 0
    jz strlen.done

    inc bx
    jmp strlen.check

    strlen.done:
    mov ax, bx
    ret
