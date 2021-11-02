#include "kernel.h"
#include "terminal.h"

void kernel_main() {
    kprint("\nHello, World! on ArtichOS", 0x0D);
}

uint16_t detect_bios_area_hardware() {
    const uint16_t * bda_detected_hardware_ptr = (const uint16_t *) 0x410;
    return *bda_detected_hardware_ptr;
}
