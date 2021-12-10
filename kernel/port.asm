BITS 16

GLOBAL inb, outb, inw, outw, io_wait

SECTION .boot.text

inb:
	; 0: Port
	; Ret: Result
	push bp
	mov bp, sp

	mov dx, [bp+4]

	in al, dx

	pop bp
	ret

outb:
	; 0: Port
	; 1: Data
	push bp
	mov bp, sp

	mov dx, [bp+4]
	mov ax, [bp+6]

	out dx, al

	pop bp
	ret

inw:
	; 0: Port
	; Ret: Result
	push bp
	mov bp, sp

	mov dx, [bp+4]

	in ax, dx

	pop bp
	ret

outw:
	; 0: Port
	; 1: Data
	push bp
	mov bp, sp

	mov dx, [bp+4]
	mov ax, [bp+6]

	out dx, ax

	pop bp
	ret

io_wait:
	push word 0
	push word 0x80
	call outb
	add sp, 4
	ret
