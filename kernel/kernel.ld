ENTRY(_start);

MEMORY {
    BOOTLOADER (rwx) : ORIGIN = 0x7C00, LENGTH = 0x200
    KERNEL (rwx) : ORIGIN = 0x500, LENGTH = ORIGIN(BOOTLOADER) - ORIGIN(KERNEL)
}

SECTIONS {
    .boot : {
        *(.text.boot);
        *(.data.boot);
        *(.rodata.boot);
        *(.bss.boot);
        . = 0x1FE;
        SHORT(0xAA55);
        __BOOT_END = .;
    } > BOOTLOADER

    .kernel : AT(__BOOT_END) {
        *(.text);
        *(.data);
        *(.rodata);
        *(.bss);
    } > KERNEL
}
