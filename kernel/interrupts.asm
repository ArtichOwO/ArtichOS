[bits 16]

global kbd_get_key
global scrn_toggle_intensity
global scrn_toggle_blink

; Keyboard
kbd_get_key:
  mov ah, 0x00
  int 0x16
  ret

; Screen
scrn_toggle_intensity:
  mov ax, 0x1003
  xor bh, bh
  mov bl, 0x00
  int 0x10
  ret

scrn_toggle_blink:
  mov ax, 0x1003
  mov bl, 0x01
  int 0x10
  ret

