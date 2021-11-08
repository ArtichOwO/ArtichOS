[bits 16]

section .boot.text

print:
  pusha
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
  popa
  ret
