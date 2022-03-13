BITS 16

GLOBAL io_wait

SECTION .text

io_wait:
    xor al, al
    out 0x80, al

    ret
