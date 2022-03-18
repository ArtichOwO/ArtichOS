BITS 16

kernel_offset      equ 0x500
temp_buffer_offset equ 0x7E00

GLOBAL load_kernel, kernel_offset
EXTERN boot_drive, vga_print_string, newline_string, read_sector, read_cluster

EXTERN \
    BPB_BytsPerSec, \
    BPB_NumFATs, \
    BPB_RootEntCnt, \
    BPB_FATSz16

SECTION .text.boot

load_kernel:
    mov ax, 32
    mov si, [BPB_RootEntCnt]
    mul si
    div word [BPB_BytsPerSec]
    mov cx, ax

    mov ax, [BPB_FATSz16]
    mul byte [BPB_NumFATs]
    add ax, 1
    xor dx, dx

    push word 0
    pop es
    mov bx, temp_buffer_offset

    call read_sector
    jnc load_kernel.root_success

    mov si, disk_error_string
    call vga_print_string
    jmp $

    load_kernel.root_success:
    mov si, system_filename_loading
    call vga_print_string

    mov cx, [BPB_RootEntCnt]
    load_kernel.search_loop:
    dec cx

    cmp cx, 0
    jz load_kernel.search_loop.error

    push cx
    cld
    mov ax, 32
    mul cl
    add ax, temp_buffer_offset
    mov si, ax
    mov di, system_filename
    mov cx, 11
    cmp cx, cx
    repe cmpsb
    pop cx
    jnz load_kernel.search_loop

    push word [es:si+0xF]

    mov si, system_filename_found
    call vga_print_string
    
    mov cx, [BPB_FATSz16]
    push word 0
    pop es
    mov bx, temp_buffer_offset
    mov ax, 1
    xor dx, dx
    call read_sector

    pop si
    push word 0
    pop es
    mov bx, kernel_offset
    mov di, temp_buffer_offset

    call read_cluster

    mov si, system_file_loaded
    call vga_print_string

    ret

    load_kernel.search_loop.error:
    mov si, system_filename_error
    call vga_print_string
    jmp $

SECTION .rodata.boot

disk_error_string db "DSK ERR",0
system_filename db "SYSTEM  SYS"
system_filename_error db `SYSTEM.SYS?\n\r`,0
system_filename_found db `SYSTEM.SYS!\n\r`,0
system_filename_loading db `ROOT\n\r`,0
system_file_loaded db `Booting\n\r`,0
