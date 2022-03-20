boot_obj += $(addprefix $(BUILD_DIR)/kernel/boot/, \
	boot.o \
	load_kernel.o \
	read_sector.o \
	read_cluster.o \
)

stdlib_obj += $(addprefix $(BUILD_DIR)/kernel/stdlib/, \
	string/memset.o \
	string/memcpy.o \
	string/strlen.o \
	string/strrev.o \
	itoa.o \
)

obj += $(boot_obj) \
	   $(stdlib_obj) \
	   $(addprefix $(BUILD_DIR)/kernel/, \
	main.o \
	port.o \
	vga_text.o \
)

ld_script += kernel/kernel.ld
