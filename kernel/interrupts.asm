[bits 16]

global kbd_get_key

; Keyboard
kbd_get_key:
  mov ah, 0x00
  int 0x16
  ret
