BITS 16

kernel_offset equ 0x500
sector_quantity equ 59

GLOBAL load_kernel, kernel_offset
EXTERN boot_drive, write_serial_string, \
       newline_string

SECTION .boot.text

print_disk_type:
    push bp
    mov bp, sp

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
    push word disk_string
    call write_serial_string
    add sp, 2
    call write_serial_string
    add sp, 2
    push word newline_string
    call write_serial_string
    add sp, 2

    pop bp
    ret

load_kernel:
    push bp
    mov bp, sp

    call print_disk_type

    mov dl, [boot_drive]
    mov ah, 02h
    mov al, sector_quantity
    mov cx, 0002h
    xor dh, dh
    mov bx, kernel_offset

    int 13h
    jnc load_kernel.end

    push word disk_error_string
    call write_serial_string
    add sp, 2
    jmp $

    load_kernel.end:
    pop bp
    ret

SECTION .boot.rodata

floppy db "FLP",0
disk db "IDE",0
unknown_disk db "???",0
disk_string db "DSK: ",0
disk_error_string db "DSK ERR",0
