kernel_offset equ 0x1000
sector_quantity equ 0x30

[bits 16]
[org 0x7c00] ; this MBR code resides here (512 bytes)

mov [boot_drive], dl ; BIOS place drive into dl when loading boot sector

xor ax, ax
mov ds, ax ; DS=0
mov es, ax ; ES=0

mov ss, ax ; Stack addresses
mov sp, ax ; Place SS:SP at 0000h:0000h
cld

mov al, 03h
mov ah, 0
int 0x10

mov si, fstmsg
call print

mov ah, 0
int 0x16 ; Wait for user input

mov si, ldamsg
call print

print_drive: ; Print `boot_drive`
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

jmp kernel_offset ; Jump to kernel
jmp $

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

; HEX PRINTING
print_hex:
  pusha
  mov cx, 0 ; our index variable
  ; Get the last char of 'dx', then convert to ASCII
  ; Numeric ASCII values: '0' (ASCII 0x30) to '9' (0x39), so just add 0x30 to byte N.
  ; For alphabetic characters A-F: 'A' (ASCII 0x41) to 'F' (0x46) we'll add 0x40
  ; Then, move the ASCII byte to the correct position on the resulting string
  hex_loop:
    cmp cx, 4 ; loop 4 times
    je end
    ; 1. convert last char of 'dx' to ascii
    mov ax, dx ; we will use 'ax' as our working register
    and ax, 0x000f ; 0x1234 -> 0x0004 by masking first three to zeros
    add al, 0x30 ; add 0x30 to N to convert it to ASCII "N"
    cmp al, 0x39 ; if > 9, add extra 8 to represent 'A' to 'F'
    jle step2
    add al, 7 ; 'A' is ASCII 65 instead of 58, so 65-58=7
  step2:
    ; 2. get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx  ; our index variable
    mov [bx], al ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234
    ; increment index and loop
    add cx, 1
    jmp hex_loop
  end:
    ; prepare the parameter and call the function
    ; remember that print receives parameters in 'bx'
    mov si, HEX_OUT
    call print
    popa
    ret


; Data
fstmsg db "Booting successful...",10,13,"Press any key to load disk!",10,13,10,13,0
drivemsg db "Drive : ",0
ldamsg db "Loading kernel into RAM...",10,13,0
errmsg db "Error loading sector, error code: ",0
retry db "Retrying using different drive...",10,13,0
newline db 10,13,0
boot_drive db 0x80 ; Will change if wrong
HEX_OUT db '0x0000',0

times 510 - ($-$$) db 0 ; Padding
dw 0xaa55 ; Signature
