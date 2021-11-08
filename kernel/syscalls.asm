;
; https://wiki.osdev.org/System_Calls
;

[bits 16]

global setup128
extern kprint, print_char

section .text

setup128:
  cli
  mov word [0x0200], int128handler
  mov word [0x0202], 0x0000
  sti
  ret

;*=================================*
; Select system call number with DI
; 4 args max (AX, BX, CX & DX)
; Define function like this :
;```c
;static void function_name(type arg1, {...}, type arg4) {
;    __asm__("mov ${num}, %%di; int $0x80"
;            :: "a" (arg1), {...}, "d" (arg4));
;}
;```
;Define assembly handler like this :
;```asm
;kernel_{function_name}:
;  cmp di, {num}
;  jne {error|next_function}
;  push 0x0000
;  push dx
;  {...}
;  push 0x0000
;  push ax
;  call 0:function_name
;  add sp, {argc * 4} ; clean up stack
;  jmp end
;```
;*=================================*

int128handler:
  pop word [Int128Offset]
  pop word [Int128Segment]
  pop word [Int128Flags]

  kernel_print:
    cmp di, 0x0000
    jne kernel_print_char
    push 0x0000
    push bx
    push 0x0000
    push ax
    call 0:kprint
    add sp, 8
    jmp end
  kernel_print_char:
    cmp di, 0x0001
    jne error
    push 0x0000
    push dx
    push 0x0000
    push cx
    push 0x0000
    push bx
    push 0x0000
    push ax
    call 0:print_char
    add sp, 14
    jmp end
  error:
    mov di, 0
    mov ax, ErrorMsg
    mov bx, 0x0C
    jmp kernel_print
  end:
    push word [Int128Flags]
    push word [Int128Segment]
    push word [Int128Offset]
    iret

section .rodata

ErrorMsg db 0xA, "Syscall not found",0

section .data

Int128Offset dw 0x0000
Int128Segment dw 0x0000
Int128Flags dw 0x0000
