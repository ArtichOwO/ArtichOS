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

uint8_t reset_disk(uint8_t drive) {
    uint8_t code;

    __asm__("movb %1, %%dl;"
            "xor %%ax, %%ax;"
            "int $0x13;"
            "movb %%ah, %0;"
            :"=m" (code)
            :"m" (drive));

    return code;
}

CHSDiskAddressPacket * LBA_to_CHS(uint8_t drive, uint32_t LBA, uint8_t sector_count,
                                  uint16_t buffer_segment, uint16_t buffer_offset) {

    CHSDiskAddressPacket packet = {
        .Drive = drive,
        .SectorCount = sector_count,
        .BufferSegment = buffer_segment,
        .BufferOffset = buffer_offset,
    }, *packet_ptr = &packet;

    uint8_t number_of_heads;
    uint8_t sectors_per_track;

    __asm__("movb %2, %%dl;"
            "movb $8, %%ah;"
            "int $0x13;"
            "movb %%dh, %0;"
            "movb %%cl, %1;"
    :"=m" (number_of_heads),
     "=m" (sectors_per_track)
    :"m" (drive));

    number_of_heads++;
    sectors_per_track &= 0x3f;

    packet.Head = (LBA % (sectors_per_track * 2)) / sectors_per_track;
    packet.Cylinder = LBA / (sectors_per_track * 2);
    packet.Sector = LBA % sectors_per_track + 1;

    return packet_ptr;
}
