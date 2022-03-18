BITS 16

GLOBAL BS_jmpBoot, boot_drive
EXTERN load_kernel, kmain, vga_print_string

GLOBAL \
    BS_OEMName, \
    BPB_BytsPerSec, \
    BPB_SecPerClus, \
    BPB_RsvdSecCnt, \
    BPB_NumFATs, \
    BPB_RootEntCnt, \
    BPB_TotSec16, \
    BPB_Media, \
    BPB_FATSz16, \
    BPB_SecPerTrk, \
    BPB_NumHeads, \
    BPB_HiddSec, \
    BPB_TotSec32, \
    BS_DrvNum, \
    BS_Reserved1, \
    BS_BootSig, \
    BS_VolID, \
    BS_VolLab, \
    BS_FilSysType

SECTION .rodata.boot.BPB

BS_jmpBoot     jmp _start
BS_OEMName     db "ArtichOS"
BPB_BytsPerSec dw 512
BPB_SecPerClus db 1
BPB_RsvdSecCnt dw 1
BPB_NumFATs    db 2
BPB_RootEntCnt dw 224
BPB_TotSec16   dw 2880
BPB_Media      db 0xF0
BPB_FATSz16    dw 9
BPB_SecPerTrk  dw 18
BPB_NumHeads   dw 2
BPB_HiddSec    dd 0
BPB_TotSec32   dd 0
BS_DrvNum      db 0
BS_Reserved1   db 0
BS_BootSig     db 0x29
BS_VolID       dd 0xCAFEBEEF
BS_VolLab      db "ArtichOS0.1"
BS_FilSysType  db "FAT 12  "

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

welcome_string db `BL loaded!\n\r`,0
