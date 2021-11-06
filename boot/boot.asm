kernel_offset equ 0x500
sector_quantity equ 59

global _start
global print
global print_hex

extern main

[bits 16]

section .boot.text

_start:
  mov [boot_drive], dl ; BIOS place drive into dl when loading boot sector

  cli

  xor ax, ax
  mov es, ax
  mov ds, ax

  mov ss, ax
  ;mov ax, 0x7c00
  mov sp, ax

  sti
  cld

  mov al, 03h
  mov ah, 0
  int 0x10

  mov si, fstmsg
  call print

  mov ah, 0
  int 0x16

  mov si, ldamsg
  call print

print_drive:
  mov si, drivemsg
  call print
  xor dh, dh
  mov dl, [boot_drive]
  call print_hex
  mov si, newline
  call print

load_disk:
  mov dl, [boot_drive]
  mov ah, 02h             ; AH=2 disk read,
  mov al, sector_quantity ; AL = number sectors to read = sector_quantity
  mov cx, 0002h           ; CH=Cylinder number 0, CL=sector to start reading = 2
                          ;    Sector 2 = sector right after boot sector
  xor dh, dh              ; DH=head number = 0
  mov bx, kernel_offset   ; ES:BX = memory to read into. ES=0, BX=kernel_offset right
                          ;    after the first 512 bytes read by BIOS
  int 13h                 ; Int 13h/AH=02 disk read
  jc disk_error

  cmp al, sector_quantity
  jne error

  jmp main

disk_error:
  call error ; Print error msg
  mov si, retry
  call print
  mov dl, [boot_drive]
  cmp dl, 0x00 ; Change boot_drive to 0x80 if already 0x00, else change to 0x00
  je change_to_80h
  mov dl, 0x00
  mov [boot_drive], dl
  jmp disk_done
  change_to_80h:
  mov dl, 0x80
  mov [boot_drive], dl
  disk_done:
  jmp print_drive ; Retry loading disk

error:
	mov si, errmsg
	call print
	mov dx, ax
	call print_hex
  mov si, newline
  call print
	ret

%include "boot/print.asm"
%include "boot/print_hex.asm"

section .boot.data

; Data
fstmsg db "Booting successful...",10,13,"Press any key to load disk!",10,13,10,13,0
drivemsg db "Drive : ",0
ldamsg db "Loading kernel into RAM...",10,13,0
errmsg db "Error loading sector, error code: ",0
retry db "Retrying using different drive...",10,13,0
newline db 10,13,0
boot_drive db 0x80 ; Will change if wrong
