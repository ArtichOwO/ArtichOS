BITS 16

GLOBAL read_cluster
EXTERN read_sector

EXTERN \
    BPB_BytsPerSec, \
    BPB_SecPerClus, \
    BPB_RootEntCnt, \
    BPB_FATSz16

SECTION .text.boot

read_cluster:
    ; ES:BX -> buffer
    ; SI: Cluster
    ; DI: FAT buffer

    pusha

    read_cluster.next:
    push si
    mov ax, 32
    mov si, [BPB_RootEntCnt]
    mul si
    div word [BPB_BytsPerSec]
    mov cx, ax

    mov ax, 2
    mov si, [BPB_FATSz16]
    mul si
    add ax, 1
    add cx, ax
    pop si

    push si
    sub si, 2
    xor ah, ah
    mov al, [BPB_SecPerClus]
    mul si
    add ax, cx
    xor dx, dx

    xor ch, ch
    mov cl, [BPB_SecPerClus]

    call read_sector

    pop si

    push cx
    push dx
    push bx

    mov cx, si
    mov dx, si
    shr dx, 1
    add cx, dx
    mov bx, di
    add bx, cx
    mov dx, [bx]
    test si, 1
    jz even_cluster

    odd_cluster:
    shr dx, 4
    jmp done

    even_cluster:
    and dx, 0xFFF

    done:
    mov si, dx

    pop bx
    pop dx
    pop cx

    mov ax, 0x200
    mul cx
    add bx, ax

    cmp si, 0xFF8
    jc read_cluster.next

    popa
    ret
