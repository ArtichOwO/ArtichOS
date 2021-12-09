ENTRY(_start);

MEMORY {
	BOOTLOADER (rwx) : ORIGIN = 0x7C00, LENGTH = 0x200
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
}
