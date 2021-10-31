#include "terminal.h"
#include "kernel.h"

enum video_type get_bios_area_video_type() {
    return (enum video_type) (detect_bios_area_hardware() & 0x30);
}

uintptr_t get_video_address(enum video_type videoType) {
    if (videoType != VIDEO_TYPE_NONE) {
        if (videoType == VIDEO_TYPE_COLOUR) {
            return (uintptr_t)0xB8000;
        } else {
            return (uintptr_t)0xB0000;
        }
    } else {
        return 0;
    }
}
