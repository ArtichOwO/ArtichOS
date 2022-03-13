BITS 16

kernel_offset equ 0x500
sector_quantity equ 59

GLOBAL load_kernel, kernel_offset
EXTERN boot_drive, vga_print_string, newline_string

SECTION .text.boot

print_disk_type:
    print_disk_type.floppy:
    cmp byte [boot_drive], 0
    jne print_disk_type.disk
    push word floppy
    jmp print_disk_type.end
    print_disk_type.disk:
    cmp byte [boot_drive], 0x80
    jne print_disk_type.unknown_disk
    push word disk
    jmp print_disk_type.end
    print_disk_type.unknown_disk:
    push word unknown_disk

    print_disk_type.end:
    mov si, disk_string
    call vga_print_string

    pop si
    call vga_print_string
    
    mov si, newline_string
    call vga_print_string

    ret

load_kernel:
    call print_disk_type

    mov dl, [boot_drive]
    mov ah, 02h
    mov al, sector_quantity
    mov cx, 0002h
    xor dh, dh
    mov bx, kernel_offset

    int 13h
    jnc load_kernel.end

    mov si, disk_error_string
    call vga_print_string
    jmp $

    load_kernel.end:
    ret

SECTION .rodata.boot

floppy db "FLP",0
disk db "IDE",0
unknown_disk db "???",0
disk_string db "DSK: ",0
disk_error_string db "DSK ERR",0
