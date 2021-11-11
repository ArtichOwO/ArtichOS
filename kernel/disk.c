/*
 * https://wiki.osdev.org/ATA_in_x86_RealMode_(BIOS)
 */

#include "disk.h"

uint8_t rw_disk(CHSDiskAddressPacket * packet, bool write) {
    uint8_t code;

    uint16_t AX = (write ? 0x0300 : 0x0200) + packet->SectorCount;
    uint16_t CX = (packet->Cylinder * 0x100) + (packet->Sector & 0x3F);
    uint16_t DX = (packet->Head * 0x100) + packet->Drive;

    __asm__("cld;"
            "movw %1, %%es;"
            "int $0x13;"
            "movb %%ah, %0;"
            :"=m" (code)
            :"m" (packet->BufferSegment),
             "a" (AX),
             "b" (packet->BufferOffset),
             "c" (CX),
             "d" (DX));

    return code;
}
