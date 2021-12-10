boot_obj += $(addprefix $(BUILD_DIR)/kernel/boot/, \
	boot.o \
	load_kernel.o \
)

obj += $(boot_obj) \
	   $(addprefix $(BUILD_DIR)/kernel/, \
	port.o \
	serial.o \
)

ld_script += kernel/kernel.ld
