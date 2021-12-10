kernel_offset equ 0x500
sector_quantity equ 59

GLOBAL _start
EXTERN init_serial, write_serial_string

BITS 16

SECTION .boot.text

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

    mov al, 03h
    mov ah, 0
    int 0x10

    call init_serial
    cmp ax, 0
    jnz _start.no_serial

    push word welcome_string
    call write_serial_string
    add sp, 2

    mov ah, 0
    int 0x16

    _start.no_serial:

    jmp $

SECTION .boot.data

boot_drive db 0x00

SECTION .boot.rodata

welcome_string db "Hello, World! on ArtichOS",0x0A,0x0D,0
