ENTRY(_start);

MEMORY {
    BOOTLOADER (rwx) : ORIGIN = 0x7C00, LENGTH = 0x200
    KERNEL (rwx) : ORIGIN = 0x500, LENGTH = ORIGIN(BOOTLOADER) - ORIGIN(KERNEL)
}

SECTIONS {
    .boot : {
        *(.boot.text);
        *(.boot.data);
        *(.boot.rodata);
        . = 0x1FE;
        SHORT(0xAA55);
        __BOOT_END = .;
    } > BOOTLOADER

    .kernel : AT(__BOOT_END) {
        *(.kernel.text);
        *(.kernel.data);
        *(.kernel.rodata);
        *(.kernel.bss);
    } > KERNEL
}
