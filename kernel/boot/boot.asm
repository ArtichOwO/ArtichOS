BITS 16

GLOBAL _start, boot_drive, newline_string
EXTERN init_serial, write_serial_string, \
       load_kernel, kmain

%include "kernel/tui_char.asm"

SECTION .boot.text

_start:
    push bp
    mov bp, sp

    mov [boot_drive], dl

    cli

    xor ax, ax
    mov es, ax
    mov ds, ax

    mov ss, ax
    mov sp, ax

    sti
    cld

    call init_serial
    cmp ax, 0
    jnz _start.no_serial

    push word welcome_string
    call write_serial_string
    add sp, 2

    jmp _start.load_kernel

    _start.no_serial:
    jmp $

    _start.load_kernel:
    call load_kernel
    jmp kmain

SECTION .boot.data

boot_drive db 0x00

SECTION .boot.rodata

welcome_string db newline,red_text,"Booting...",reset_color_text,newline,0
newline_string db newline,0
