[bits 16]

global main

extern print, kernel_main

section .text

main:
  mov si, KernelMsg
  call print

  call kernel_main
  jmp $

section .data

KernelMsg db "Kernel loaded!", 0
