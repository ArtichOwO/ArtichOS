ENTRY(BS_jmpBoot);

MEMORY {
    BOOTLOADER (rwx) : ORIGIN = 0x7C00, LENGTH = 0x200
    KERNEL (rwx) : ORIGIN = 0x500, LENGTH = ORIGIN(BOOTLOADER) - ORIGIN(KERNEL)
}

SECTIONS {
    .boot : {
        *(.rodata.boot.BPB);

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
