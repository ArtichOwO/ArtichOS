BITS 16

GLOBAL vga_print_string

SECTION .text.boot

vga_print_string:
    ; SI: String
    ; BL: Color

    mov bh, 0
    mov ah, 0x0E

    vga_print_string.is_null:
    mov al, [si]
    cmp al, 0
    jz vga_print_string.end

    int 0x10
    inc si
    jmp vga_print_string.is_null
    
    vga_print_string.end:
    ret
