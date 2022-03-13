BITS 16

GLOBAL _start, boot_drive, newline_string
EXTERN load_kernel, kmain, vga_print_string

SECTION .text.boot

_start:
    mov [boot_drive], dl

    cli

    xor ax, ax
    mov es, ax
    mov ds, ax

    mov ss, ax
    mov sp, ax

    sti
    cld

    mov si, welcome_string
    mov bl, 0x0C
    call vga_print_string

    jmp _start.load_kernel

    _start.load_kernel:
    call load_kernel
    jmp kmain

SECTION .data.boot

boot_drive db 0x00

SECTION .rodata.boot

welcome_string db `\n\rBootloader successfully loaded! \n\r`,0
newline_string db `\n\r`,0
