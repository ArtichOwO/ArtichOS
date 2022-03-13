BITS 16

GLOBAL kmain
EXTERN vga_print_string

SECTION .text

kmain:
    mov si, welcome_string
    call vga_print_string

    jmp $

SECTION .rodata

welcome_string db \
    `\n\r+--------------+\n\r`, \
        `|Kernel loaded!|\n\r`, \
        `+--------------+\n\r`, \
        `| Welcome! :3  |\n\r`, \
        `+--------------+\n\r`,0

