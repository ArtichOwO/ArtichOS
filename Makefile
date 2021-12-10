BUILD_DIR = output
ASM = nasm
LD = x86_64-elf-ld

ASM_FLAGS = -Wx
LD_FLAGS = --oformat binary -m elf_i386

include kernel/Makefile

ArtichOS.bin: $(obj)
	@echo LD $@
	@$(LD) $^ -T $(ld_script) -o $(BUILD_DIR)/$@ $(LD_FLAGS)

.PHONY: clean run all

clean:
	@rm -Rf $(BUILD_DIR)
	@echo CLEAN

run: ArtichOS.bin
	qemu-system-i386 -drive format=raw,file=$(BUILD_DIR)/$<,index=0,if=floppy \
	                 -monitor stdio -serial file:output/serial.log

all: clean run

$(BUILD_DIR)/%.o: %.asm
	@mkdir -p $(dir $@)
	@echo ASM $@
	@$(ASM) -f elf $^ -o $@ $(ASM_FLAGS)

$(BUILD_DIR)/%.bin: %.asm
	@mkdir -p $(dir $@)
	@echo ASM $@
	@$(ASM) -f bin $^ -o $@ $(ASM_FLAGS)
