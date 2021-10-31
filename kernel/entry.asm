[bits 16]

global main

[extern print]
[extern print_hex]
[extern kernel_main]

section .text

main:
  mov si, KernelMsg
  call print

  call kernel_main
  jmp $

section .data

KernelMsg db "Kernel loaded!", 0
