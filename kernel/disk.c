/*
 * https://wiki.osdev.org/ATA_in_x86_RealMode_(BIOS)
 */

#include "disk.h"

bool rw_disk(CHSDiskAddressPacket * packet, bool write) {
    bool success;

    uint16_t AX = packet->SectorCount;
    if (write)
        AX += 0x0300;
    else
        AX += 0x0200;
    uint16_t CX = (packet->Cylinder * 0x100) + packet->Sector;
    uint16_t DX = (packet->Head * 0x100) + packet->Drive;

    __asm__("cld;"
            "mov %5, %%es;"
            "int $0x13;"
            "jc 1f;"
            "movw $1, %0;"
            "jmp 2f;"
            "1: movw $0, %0;"
            "2:;"
            :"=m" (success)
            :"a" (AX),
             "b" (packet->BufferOffset),
             "c" (CX),
             "d" (DX),
             "m" (packet->BufferSegment));

    return success;
}
