#ifndef KERNEL_DISK_H
#define KERNEL_DISK_H

#include <stdbool.h>
#include <stdint.h>

extern uint8_t boot_drive;

static char * messages[] = {
    "Success",
    "Invalid Command",
    "Cannot Find Address Mark",
    "Attempted Write On Write Protected Disk",
    "Sector Not Found",
    "Reset Failed",
    "Disk change line 'active'",
    "Drive parameter activity failed",
    "DMA overrun",
    "Attempt to DMA over 64kb boundary",
    "Bad sector detected",
    "Bad cylinder detected",
    "Media type not found",
    "Invalid number of sectors",
    "Control data address mark detected",
    "DMA out of range",
    "CRC/ECC data error",
    "ECC corrected data error",
    [0x20]="Controller failure",
    [0x40]="Seek failure",
    [0x80]="Drive timed out, assumed not ready",
    [0xAA]="Drive not ready",
    [0xBB]="Undefined error",
    [0xCC]="Write fault",
    [0xE0]="Status error",
    [0xFF]="Sense operation failed"
};

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

#endif // KERNEL_DISK_H
