#ifndef KERNEL_TERMINAL_H
#define KERNEL_TERMINAL_H

#include <stdint.h>

enum video_type {
    VIDEO_TYPE_NONE = 0x00,
    VIDEO_TYPE_COLOUR = 0x20,
    VIDEO_TYPE_MONOCHROME = 0x30,
};

enum video_type get_bios_area_video_type();
uintptr_t get_video_address(enum video_type videoType);

#endif // KERNEL_TERMINAL_H
