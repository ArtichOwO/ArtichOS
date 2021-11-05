BUILD_DIR = output/
GCC = i386-elf-gcc
GXX = i386-elf-g++
NASM = nasm
LD = i386-elf-ld

CFLAGS = -ffreestanding \
 		 -c -m16 -nostdlib -nostdinc \
         -nostartfiles -nodefaultlibs \
         -Wall -Wextra -I libc
NASM_FLAGS = -Wx
LD_FLAGS = -T main.ld --oformat binary

include boot/Makefile
include kernel/Makefile
include libc/Makefile

ArtichOS: $(obj)
	@echo LD $@
	@$(LD) $^ -o $(BUILD_DIR)$@ $(LD_FLAGS)

.PHONY: clean run all

clean:
	@rm -Rf $(BUILD_DIR)
	@echo CLEAN

run: ArtichOS
	qemu-system-i386 -drive format=raw,file=$(BUILD_DIR)$<,index=0,if=floppy \
	                 -monitor stdio -serial file:output/serial.log

all: clean run


$(BUILD_DIR)%.o: %.c
	@mkdir -p $(dir $@)
	@echo GCC $@
	@$(GCC) $< -o $@ $(CFLAGS)

$(BUILD_DIR)%.o: %.asm
	@mkdir -p $(dir $@)
	@echo NASM $@
	@$(NASM) -f elf $^ -o $@ $(NASM_FLAGS)

$(BUILD_DIR)%.bin: %.asm
	@mkdir -p $(dir $@)
	@echo NASM $@
	@$(NASM) -f bin $^ -o $@ $(NASM_FLAGS)
