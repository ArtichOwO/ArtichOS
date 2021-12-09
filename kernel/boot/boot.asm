kernel_offset equ 0x500
sector_quantity equ 59

GLOBAL _start

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

    mov ah, 0
    int 0x16

    jmp $

SECTION .boot.data

boot_drive db 0x00
