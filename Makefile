BUILD_DIR = output
ASM = nasm
LD = x86_64-elf-ld

ASM_FLAGS = -Wx
LD_FLAGS = --oformat binary -m elf_i386

include kernel/Makefile

ArtichOS.img: ArtichOS.bin
	@echo MKDIR $(BUILD_DIR)/root
	@mkdir -p $(BUILD_DIR)/root
	@echo CP $(BUILD_DIR)/root
	@cp -Ra root/. $(BUILD_DIR)/root/
	@echo FAT $(BUILD_DIR)/root/system.sys
	@python3 utils/fat.py $(BUILD_DIR)/$< --export-kernel $(BUILD_DIR)/root/system.sys

	@echo MFORMAT $@
	@#mformat -s 8 -t 5 -h 1 -1 -r 1 -B $(BUILD_DIR)/$< -v ArtichOS -C i:
	@mformat -f 1440 -B $(BUILD_DIR)/$< -v ArtichOS -C i:
	@echo MCOPY root
	@mcopy -snv $(BUILD_DIR)/root/* i:

ArtichOS.bin: $(obj)
	@echo LD $@
	@$(LD) $^ -T $(ld_script) -o $(BUILD_DIR)/$@ $(LD_FLAGS)

.PHONY: clean run all

clean:
	@rm -Rf $(BUILD_DIR)
	@echo CLEAN

run: ArtichOS.img
	qemu-system-i386 -drive format=raw,file=$(BUILD_DIR)/$<,index=0,if=floppy

all: clean run

$(BUILD_DIR)/%.o: %.asm
	@mkdir -p $(dir $@)
	@echo ASM $@
	@$(ASM) -f elf $^ -o $@ $(ASM_FLAGS)

$(BUILD_DIR)/%.bin: %.asm
	@mkdir -p $(dir $@)
	@echo ASM $@
	@$(ASM) -f bin $^ -o $@ $(ASM_FLAGS)
