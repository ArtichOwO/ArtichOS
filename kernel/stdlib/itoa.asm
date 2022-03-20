BITS 16

GLOBAL itoa

EXTERN strrev

SECTION .text

itoa:
    ; AX: Num
    ; ES:DI -> Buffer
    ; BX: Base
    ; Ret(ES:DI) -> Buffer

    cmp ax, 0
    jnz itoa.not_zero
    mov byte [es:di], 0x0030
    jmp itoa.done
    itoa.not_zero:

    push di

    xor cx, cx

    itoa.check:
    cmp ax, 0
    jz itoa.done_not_zero

    push ax
    xor dx, dx
    div bx
    pop ax

    cmp dx, 9
    ja itoa.letter
    itoa.digit:
    add dx, '0'
    jmp itoa.store_char
    itoa.letter:
    sub dx, 10
    add dx, 'a'
    itoa.store_char:
    mov [es:di], dl
    inc di

    xor dx, dx
    div bx
    jmp itoa.check

    itoa.done_not_zero:

    mov byte [es:di], 0

    pop di

    itoa.done:
    mov ax, di
    call strrev

    ret
