BITS 16

GLOBAL strrev

EXTERN strlen

SECTION .text

strrev:
    ; ES:AX -> String
    ; Ret(ES:AX) -> Reversed tring

    push ax

    mov si, ax
    call strlen
    mov bx, ax

    pop ax

    mov di, ax
    lea di, [di+bx-1]

    strrev.loop:
    cmp si, di
    jz strrev.done

    mov dl, [si]
    mov dh, [di]
    mov [si], dh
    mov [di], dl

    inc si
    dec di

    strrev.done:
    ret
