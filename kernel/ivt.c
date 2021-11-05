#include "ivt.h"
#include "terminal.h"
#include "port.h"
#include <stdint.h>
#include <stdlib.h>

#define ERROR_SCREEN_COLOR 0x9A

struct IVTentry {
    uint16_t function;
    uint16_t segment;
};

static void error_screen(char *message) {
    //port_byte_out(0x10, 0b00000111);
    __asm__("mov $0x1003, %ax; int $0x10");

    char reg_str[6] = {0};
    uint16_t reg_content;

    set_cursor_shape(0x2607);
    clear_terminal(' ', ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(4, 5));
    kprint(message, ERROR_SCREEN_COLOR);
    set_cursor_offset(get_offset(4, 7));
    kprint("Your PC has encountered a fatal error, \n"
           "    to continue : \n\n"
           "    Try to reboot your computer, \n"
           "    if the error persists \n"
           "    try to reinstall ArtichOS.", ERROR_SCREEN_COLOR);


    set_cursor_offset(get_offset(50, 7));
    __asm__("mov %%ax, %0" : "=m" (reg_content));
    kprint("AX=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(50, 8));
    __asm__("mov %%bx, %0" : "=m" (reg_content));
    kprint("BX=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(65, 7));
    __asm__("mov %%cx, %0" : "=m" (reg_content));
    kprint("CX=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(65, 8));
    __asm__("mov %%dx, %0" : "=m" (reg_content));
    kprint("DX=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);


    set_cursor_offset(get_offset(50, 10));
    __asm__("mov %%sp, %0" : "=m" (reg_content));
    kprint("SP=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(50, 11));
    __asm__("mov %%ss, %0" : "=m" (reg_content));
    kprint("SS=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(65, 10));
    __asm__("mov %%cs, %0" : "=m" (reg_content));
    kprint("CS=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(65, 11));
    __asm__("mov %%ds, %0" : "=m" (reg_content));
    kprint("DS=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);


    set_cursor_offset(get_offset(50, 13));
    __asm__("mov %%si, %0" : "=m" (reg_content));
    kprint("SI=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    set_cursor_offset(get_offset(65, 13));
    __asm__("mov %%di, %0" : "=m" (reg_content));
    kprint("DI=0x", ERROR_SCREEN_COLOR);
    kprint(itoa(reg_content, reg_str, 16), ERROR_SCREEN_COLOR);

    __asm__("hlt");
}

static void IVTzero() { error_screen("Division by zero x(\n"); }
/* IVTone -> reserved */
static void IVTtwo() { error_screen("NMI T^T\n"); }
static void IVTthree() { error_screen("Breakpoint :c\n"); }
static void IVTfour() { error_screen("Overflow >:0\n"); }

void setupIVT() {
    volatile struct IVTentry * IVTptr = (struct IVTentry *) 0x0000;

    /*
     * https://www.tutorialspoint.com/microprocessor/microprocessor_8086_interrupts.htm
     *
     * The first five pointers are dedicated interrupt pointers.
     * The interrupts from Type 5 to Type 31 are reserved for other advanced microprocessors,
     * and interrupts from 32 to Type 255 are available for hardware and software interrupts.
     */

    void * functions[] = {
        (void *)&IVTzero,
        (void *)0, // Debug
        (void *)&IVTtwo,
        (void *)&IVTthree,
        (void *)&IVTfour,
    };

    __asm__ __volatile__ ("cli");

    for (unsigned int i = 0; i < 5; ++i) {
        if (i != 1) {
            IVTptr[i].function = (uint16_t)functions[i];
            IVTptr[i].segment = 0x0000;
        }
    }

    __asm__ __volatile__ ("sti");
}

/*
 * https://stackoverflow.com/questions/282983/setting-up-irq-mapping
 */

void remapIRQ() {
    port_byte_out(0x20, 0x11);
    port_byte_out(0xA0, 0x11);
    port_byte_out(0x21, 0x20);
    port_byte_out(0xA1, 0x28);
    port_byte_out(0x21, 0x04);
    port_byte_out(0xA1, 0x02);
    port_byte_out(0x21, 0x01);
    port_byte_out(0xA1, 0x01);
    port_byte_out(0x21, 0x0);
    port_byte_out(0xA1, 0x0);
}
