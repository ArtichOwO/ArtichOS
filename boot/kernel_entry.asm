; TODO: rewrite this shit
[bits 16]
[extern main]

mov si, msg_kern
call print

call main
jmp $

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

msg_kern db "Kernel loaded, welcome to ArtichOS!",0
