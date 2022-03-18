BITS 16

; https://github.com/alexfru/BootProg/blob/master/boot12.asm 
; -> ReadSector

GLOBAL read_sector
EXTERN boot_drive

EXTERN \
    BPB_BytsPerSec, \
    BPB_SecPerTrk, \
    BPB_NumHeads

SECTION .text.boot

read_sector:
        ; DX:AX = LBA
        ; CX = sector count
        ; ES:BX -> buffer
        ; Ret: CF set if error

        pusha

read_sector.next:
        mov di, 5 ; Attempts to read

read_sector.retry:
        pusha

        div word [BPB_SecPerTrk]
        ; ax = LBA / SPT
        ; dx = LBA % SPT = sector - 1

        mov cx, dx
        inc cx
        ; cx = sector no.

        xor dx, dx
        div word [BPB_NumHeads]
        ; ax = (LBA / SPT) / HPC = cylinder
        ; dx = (LBA / SPT) % HPC = head

        mov ch, al
        ; ch = LSB 0...7 of cylinder no.
        shl ah, 6
        or cl, ah
        ; cl = MSB 8...9 of cylinder no. + sector no.

        mov dh, dl
        ; dh = head no.

        mov dl, [boot_drive]
        ; dl = drive no.

        mov ax, 201h
        ; al = sector count = 1
        ; ah = 2 = read function no.

        int 13h ; Read sectors
        jnc read_sector.done ; CF = 0 if no error

        xor ah, ah ; ah = 0 = reset function
        int 13h ; Reset drive

        popa
        dec di
        jnz read_sector.retry ; Extra attempt
        ret

read_sector.done:
        popa
        dec cx
        jz read_sector.done.2 ; Last sector

        add bx, [BPB_BytsPerSec] ; Adjust offset for next sector
        add ax, 1
        adc dx, 0 ; Adjust LBA for next sector
        jmp short read_sector.next

read_sector.done.2:
        popa
        ret
