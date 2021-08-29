[bits 16]
[extern print]
[extern print_hex]

global init
global shutdown
global hardware_reset

init:
	pusha
	call apm_get_version
	mov [apm_ver], ax
	mov [apm_pm_ascii], bx

	mov si, nl
	call print
	mov si, apm_pm_ascii
	call print
	mov dx, apm_ver
	call print_hex
	mov si, nl
	call print

	call apm_connect
	mov dx, [apm_ver]
	call apm_set_version
	call apm_en_pwr_man

	popa
	ret

apm_get_version:
	;perform an installation check
	mov ah, 53h
	mov al, 00h            ;installation check command
	xor bx, bx             ;device id (0 = APM BIOS)
	int 15h
	jc apm_error
	ret

apm_connect:
	;connect to an APM interface
	mov ah, 53h
	mov al, 01h                ; Real mode
	xor bx, bx                 ; device id (0 = APM BIOS)
	int 15h
	jc apm_error
	ret

apm_disconnect:
	;disconnect from any APM interface
	mov ah, 53h
	mov al, 04h              ;interface disconnect command
	xor bx, bx               ;device id (0 = APM BIOS)
	int 15h
	jc .disconnect_error
	jmp .no_error
	 
	.disconnect_error:       ;the error code is in ah.
	cmp ah, 03h              ;if the error code is anything but 03h there was an error.
	jne apm_error            ;the error code 03h means that no interface was connected in the first place.
	 
	.no_error:
 	ret

apm_set_version:
	mov ah, 53h
	mov al, 0eh            ;set driver supported version command
	xor bx, bx             ;device ID of system BIOS
	mov cx, dx
	int 15h
	jc .version_error
	;at this point AX holds the APM version that is connected, AH=major version AL=minor version
	;so an additional check might be implemented
	jmp .no_error
	.version_error:
	;ah can hold: 03h if the interface wasn't connected, 09h if the device ID wasn't recognised (BX nonzero), 0Bh if APM v1.1 still isn't engaged
	xor al, al
	ret
	.no_error:
	xor ax, ax
	ret

apm_en_pwr_man:
	;Enable power management for all devices
	mov ah, 53h
	mov al, 08h              ;Change the state of power management...
	mov bx, 0001h            ;...on all devices to...
	mov cx, 0001h            ;...power management on.
	int 15h
	jc apm_error
	ret

shutdown:
	;Set the power state for all devices
	mov ah, 53h
	mov al, 07h              ;Set the power state...
	mov bx, 0001h            ;...on all devices to...
	mov cx, 03h              ;...'Off'.
	int 15h
	jc apm_error

hardware_reset:
	xor ax, ax
  mov ds, ax
  mov ax, 0x1234
	mov [0x0472], ax
	jmp 0xFFFF:0000

apm_error:
	mov si, apm_err_msg
	call print
	jmp $

nl db 10,13,0
apm_ver db 0,0,0,0
apm_pm_ascii db "no",0
apm_err_msg db 10,13,"There was an error when calling BIOS APM interrupt",10,13,0
