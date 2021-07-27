#include "../drivers/screen.h"
#include "../libcxx/string.h"
#include "kernel.h"

extern "C" {
    #include "../cpu/isr.h"
}

void main() {
    isr_install();
    irq_install();

    kprint("Welcome to ArtichOS :3\n"
           "Type END to halt the CPU\n"
           ">>> ");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        kprint("Stopping the CPU. Bye!\n");
        asm volatile("hlt");
    }
    kprint("You said: ");
    kprint(input);
    kprint("\n>>> ");
}
