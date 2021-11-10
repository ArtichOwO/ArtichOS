#include "ivt.h"
#include "terminal.h"
#include "port.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#define ERROR_SCREEN_COLOR 0x9A

typedef void (*ivt_function)(void);

typedef struct {
    ivt_function function;
    uint16_t segment;
} IVTentry;

static void error_screen(char * message) {
    //port_byte_out(0x10, 0b00000111);
    __asm__("mov $0x1003, %ax; int $0x10");

    char string[80] = {0};
    uint16_t reg_content;

    set_cursor_shape(0x2607);
    clear_terminal(' ', ERROR_SCREEN_COLOR);

    kprint_at(message, ERROR_SCREEN_COLOR, 5, 4);
    kprint_at("Your PC has encountered a fatal error, \n"
              "    to continue : \n\n"
              "    Try to reboot your computer, \n"
              "    if the error persists \n"
              "    try to reinstall ArtichOS.", ERROR_SCREEN_COLOR, 7, 4);

    __asm__("mov %%ax, %0" : "=m" (reg_content));
    sprintf(string, "AX=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 7, 50);

    __asm__("mov %%bx, %0" : "=m" (reg_content));
    sprintf(string, "BX=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 8, 50);

    __asm__("mov %%cx, %0" : "=m" (reg_content));
    sprintf(string, "CX=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 7, 65);

    __asm__("mov %%dx, %0" : "=m" (reg_content));
    sprintf(string, "DX=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 8, 65);

    __asm__("mov %%sp, %0" : "=m" (reg_content));
    sprintf(string, "SP=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 10, 50);

    __asm__("mov %%ss, %0" : "=m" (reg_content));
    sprintf(string, "SS=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 11, 50);

    __asm__("mov %%cs, %0" : "=m" (reg_content));
    sprintf(string, "CS=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 10, 65);

    __asm__("mov %%ds, %0" : "=m" (reg_content));
    sprintf(string, "DS=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 11, 65);

    __asm__("mov %%si, %0" : "=m" (reg_content));
    sprintf(string, "SI=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 13, 50);

    __asm__("mov %%di, %0" : "=m" (reg_content));
    sprintf(string, "DI=0x%x", reg_content);
    kprint_at(string, ERROR_SCREEN_COLOR, 13, 65);

    __asm__("hlt");
}

static void IVTzero(void) { error_screen("Division by zero x(\n"); }
/* IVTone -> reserved */
static void IVTtwo(void) { error_screen("NMI T^T\n"); }
static void IVTthree(void) { error_screen("Breakpoint :c\n"); }
static void IVTfour(void) { error_screen("Overflow >:0\n"); }

void setupIVT(void) {
    volatile IVTentry * IVTptr = (IVTentry *) 0x0000;

    /*
     * https://www.tutorialspoint.com/microprocessor/microprocessor_8086_interrupts.htm
     *
     * The first five pointers are dedicated interrupt pointers.
     * The interrupts from Type 5 to Type 31 are reserved for other advanced microprocessors,
     * and interrupts from 32 to Type 255 are available for hardware and software interrupts.
     */

    ivt_function functions[] = {
        IVTzero,
        0, // Debug
        IVTtwo,
        IVTthree,
        IVTfour,
    };

    __asm__ __volatile__ ("cli");

    for (unsigned int i = 0; i < 5; ++i) {
        if (functions[i] != (void *)0) {
            IVTptr[i].function = functions[i];
            IVTptr[i].segment = 0x0000;
        }
    }

    __asm__ __volatile__ ("sti");
}

/*
 * https://stackoverflow.com/questions/282983/setting-up-irq-mapping
 */

void remapIRQ(void) {
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
