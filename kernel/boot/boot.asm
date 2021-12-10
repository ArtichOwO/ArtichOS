BITS 16

GLOBAL _start, boot_drive, newline_string
EXTERN init_serial, write_serial_string, \
       load_kernel, kernel_offset

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
    jmp $

SECTION .boot.data

boot_drive db 0x00

SECTION .boot.rodata

welcome_string db 0x0A,0x0D,0x1b,"[31m","Booting...",0x1b,"[0m",0x0A,0x0D,0
newline_string db 0x0A,0x0D,0
