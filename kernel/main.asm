BITS 16

GLOBAL kmain
EXTERN write_serial_string

%include "kernel/tui_char.asm"

SECTION .kernel.text

kmain:
	push bp
	mov bp, sp

	push word welcome_string
	call write_serial_string
	add sp, 2

	pop bp
	jmp $

SECTION .kernel.rodata

welcome_string db newline, \
	"旼컴컴컴컴컴컴커",newline, \
	"�",cyan_text,"Kernel loaded!",reset_color_text,"�",newline, \
	"팠袴袴袴袴袴袴孤",newline, \
	"� ",yellow_text,"Welcome! :3",reset_color_text,"  �",newline, \
	"突袴袴袴袴袴袴槁",0
