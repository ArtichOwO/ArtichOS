ENTRY(_start);

SECTIONS {
  . = 0x7C00;
  .boot.text : {
    *(.boot.text);
    . = 0x1FE;
    SHORT(0xAA55);
    __BOOT_END = .;
  }

  . = 0x500;
  .text : AT(__BOOT_END) {
    main = .;
    *(.text);
    *(.data);
  }
}
