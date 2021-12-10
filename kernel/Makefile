boot_obj += $(addprefix $(BUILD_DIR)/kernel/boot/, \
	boot.o \
)

obj += $(boot_obj) \
	   $(addprefix $(BUILD_DIR)/kernel/, \
	port.o \
)

ld_script += kernel/kernel.ld
