BITS 16

GLOBAL memset

SECTION .kernel.text

memset:
    ; 0: Buffer offset
    ; 1: Buffer segment
    ; 2: Value
    ; 3: Size
    ; Ret: Buffer offset
    push bp
    mov bp, sp

    xor cx, cx
    mov byte dl, [bp+8]

    mov ax, [bp+6]
    mov es, ax

    memset.for:
    cmp cx, [bp+10]
    je memset.end

    mov di, [bp+4]
    add di, cx
    mov [es:di], dl
    inc cx

    jmp memset.for

    memset.end:
    mov ax, [bp+4]
    pop bp
    ret
