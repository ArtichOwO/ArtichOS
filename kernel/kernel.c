#include "kernel.h"
#include "terminal.h"
#include "ivt.h"
#include "serial.h"
#include <string.h>

void kernel_main() {
    init_serial();
    //remapIRQ();
    setupIVT();

    char * WelcomeMsg = "Hello, World! on ArtichOS \x08";
    set_cursor_offset(get_offset((MAX_COLS-strlen(WelcomeMsg))/2, (MAX_ROWS/2)-1));
    kprint(WelcomeMsg, 0x0D);
}

uint16_t detect_bios_area_hardware() {
    const uint16_t * bda_detected_hardware_ptr = (const uint16_t *) 0x410;
    return *bda_detected_hardware_ptr;
}
