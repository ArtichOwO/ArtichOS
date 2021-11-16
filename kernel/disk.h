#ifndef KERNEL_DISK_H
#define KERNEL_DISK_H

#include <stdbool.h>
#include <stdint.h>

extern uint8_t boot_drive;
extern char * messages[];

typedef struct {
    uint8_t Drive;
    uint8_t SectorCount;
    uint8_t Cylinder;
    uint8_t Head;
    uint8_t Sector;
    uint16_t BufferSegment;
    uint16_t BufferOffset;
} CHSDiskAddressPacket;

uint8_t rw_disk(CHSDiskAddressPacket * packet, bool write);
uint8_t reset_disk(uint8_t drive);
CHSDiskAddressPacket * LBA_to_CHS(uint8_t drive, uint32_t LBA, uint8_t sector_count,
                                  uint16_t buffer_segment, uint16_t buffer_offset);

#endif // KERNEL_DISK_H
