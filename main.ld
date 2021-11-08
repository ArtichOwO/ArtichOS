ENTRY(_start);

MEMORY {
  bootloader (rwx) : ORIGIN = 0x7C00, LENGTH = 0x200
  kernel (rwx) : ORIGIN = 0x500, LENGTH = ORIGIN(bootloader) - ORIGIN(kernel)
}

SECTIONS {
  .boot : {
    *(.boot.text);
    *(.boot.data);
    *(.boot.rodata);
    . = 0x1FE;
    SHORT(0xAA55);
    __BOOT_END = .;
  } > bootloader

  .kernel : AT(__BOOT_END) {
    main = .;
    *(.text);
    *(.data);
    *(.rodata);
    *(.bss);
    . = 0x7700;
    __KERNEL_END = .;
  } > kernel
}
