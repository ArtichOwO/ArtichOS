; TODO: rewrite this shit
section .text
global _start

[bits 16]
[extern main]

_start:
	mov si, msg_kern
	call print

	call main
	mov si, msg_error
	call print

print:
	mov bp, sp
	cont:
	lodsb
	or al, al
	jz dne
	mov ah, 0x0e
	mov bx, 0
	int 10h
	jmp cont
	dne:
	mov sp, bp
	ret

msg_kern db "Kernel loaded, welcome to ArtichOS!",10,13,0
msg_error db "main returned; error",10,13,0
