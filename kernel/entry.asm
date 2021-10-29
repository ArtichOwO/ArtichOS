[bits 16]

global main

[extern print]
[extern print_hex]

section .text

main:
  mov si, KernelMsg
  call print

  jmp $

section .data

KernelMsg db "It worked!", 0
