BITS 16

GLOBAL memcpy

SECTION .kernel.text

memcpy:
    ; 0: Destination offset
    ; 1: Destination segment
    ; 2: Source offset
    ; 3: Source segment
    ; 4: Size
    ; Ret: Destination offset
    push bp
    mov bp, sp

    xor cx, cx

    memcpy.for:
    cmp cx, [bp+12]
    je memcpy.end

    mov ax, [bp+10]
    mov es, ax
    mov si, [bp+8]
    add si, cx
    mov byte dl, [es:si]

    mov ax, [bp+6]
    mov es, ax
    mov di, [bp+4]
    add di, cx
    mov byte [es:di], dl

    inc cx
    jmp memcpy.for

    memcpy.end:
    mov ax, [bp+4]
    pop bp
    ret
