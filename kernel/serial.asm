BITS 16

; https://wiki.osdev.org/Serial_Ports

GLOBAL init_serial, is_transmit_empty, write_serial_char, write_serial_string
EXTERN outb, inb

COM1 equ 0x3f8

SECTION .boot.text

init_serial:
    ; Ret: 1 if serial faulty, 0 if alright
    push bp
    mov bp, sp

    push word 0
    push word COM1 + 1
    call outb ; Disable all interrupts
    add sp, 4

    push word 0x80
    push word COM1 + 3
    call outb ; Enable DLAB (set baud rate divisor)
    add sp, 4

    push word 0x03
    push word COM1 + 0
    call outb ; Set divisor to 3 (lo byte) 38400 baud
    add sp, 4

    push word 0
    push word COM1 + 1
    call outb ;                  (hi byte)
    add sp, 4

    push word 0x03
    push word COM1 + 3
    call outb ; 8 bits, no parity, one stop bit
    add sp, 4

    push word 0xC7
    push word COM1 + 2
    call outb ; Enable FIFO, clear them, with 14-byte threshold
    add sp, 4

    push word 0x0B
    push word COM1 + 4
    call outb ; IRQs enabled, RTS/DSR set
    add sp, 4

    push word 0x1E
    push word COM1 + 4
    call outb ; Set in loopback mode, test the serial chip
    add sp, 4

    push word 0xAE
    push word COM1 + 0
    call outb ; Test serial chip (send byte 0xAE and check if serial returns same byte)
    add sp, 4

    ; Check if serial is faulty (i.e: not same byte as sent)
    push word COM1 + 0
    call inb
    add sp, 2

    cmp al, 0xAE
    jne init_serial.error

    ; If serial is not faulty set it in normal operation mode
    ; (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
    push word 0x0F
    push word COM1 + 4
    call outb
    add sp, 4
    mov ax, 0
    jmp init_serial.end

    init_serial.error:
    mov ax, 1
    jmp init_serial.end

    init_serial.end:
    pop bp
    ret

is_transmit_empty:
    ; Ret: Value
    push bp
    mov bp, sp

    push word COM1 + 5
    call inb
    add sp, 2

    and ax, 0x20

    pop bp
    ret

write_serial_char:
    ; 0: Char
    push bp
    mov bp, sp

    write_serial_char.is_transmit_empty:
    call is_transmit_empty
    cmp AX, 0
    jz write_serial_char.is_transmit_empty

    push word [bp+4]
    push word COM1
    call outb
    add sp, 4

    pop bp
    ret

write_serial_string:
    ; 0: String address
    push bp
    mov bp, sp

    mov si, [bp+4]
    write_serial_string.is_zero:
    cmp byte [si], 0
    jz write_serial_string.end

    push word [si]
    call write_serial_char
    add sp, 2
    inc si
    jmp write_serial_string.is_zero

    write_serial_string.end:
    pop bp
    ret
