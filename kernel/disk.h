#ifndef KERNEL_DISK_H
#define KERNEL_DISK_H

#include <stdbool.h>
#include <stdint.h>

extern uint8_t boot_drive;

struct CHSDiskAddressPacket {
    uint8_t Drive;
    uint8_t SectorCount;
    uint8_t Cylinder;
    uint8_t Head;
    uint8_t Sector;
    uint16_t BufferSegment;
    uint16_t BufferOffset;
};

bool rw_disk(struct CHSDiskAddressPacket * packet, bool write);

#endif // KERNEL_DISK_H
