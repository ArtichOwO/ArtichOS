OUTPUT_DIR = output/

NASM = nasm
GCC = i386-elf-gcc
GXX = i386-elf-g++
GDB = i386-elf-gdb
LD  = i386-elf-ld
CAT = cat

CFLAGS = -ffreestanding -c -g -m16 -nostdlib -nostdinc -fno-builtin \
				 -fno-stack-protector -nostartfiles -nodefaultlibs \
		 		 -Wall -Wextra
LDFLAGS = -Ttext 0x1000

QEMU = qemu-system-x86_64

src_dir_1 = $(wildcard */)
src_dir = $(filter-out $(OUTPUT_DIR), $(src_dir_1))

kernel_src = $(wildcard kernel/*.cpp)
kernel_src += $(wildcard kernel/*.c)
kernel_head = $(wildcard kernel/*.h)

kernel_obj_1 = $(kernel_src:.cpp=.o)
kernel_obj = $(kernel_obj_1:.c=.o)

.PHONY: all build debug clean run run_debug prebuild

all: prebuild run
build: prebuild ArtichOS.bin
debug: prebuild run_debug

ArtichOS.bin: boot/boot.bin kernel/kernel.bin
	@echo CAT $@
	@$(CAT) $(addprefix $(OUTPUT_DIR), $^) > $(OUTPUT_DIR)$@

kernel/kernel.bin: boot/kernel_entry.o $(kernel_obj)
	@echo LD $@
	@$(LD) $(LDFLAGS) --oformat binary $(addprefix $(OUTPUT_DIR), $^) -o $(OUTPUT_DIR)$@

kernel.elf: boot/kernel_entry.o $(kernel_obj)
	@echo LD $@
	@$(LD) $(LDFLAGS) $(addprefix $(OUTPUT_DIR), $^) -o $(OUTPUT_DIR)$@

%.o: %.cpp ${kernel_head}
	@echo GXX $@
	@${GXX} ${CFLAGS} $< -o $(OUTPUT_DIR)$@

%.o: %.c ${kernel_head}
	@echo GXX $@
	@${GCC} ${CFLAGS} $< -o $(OUTPUT_DIR)$@

%.o: %.asm
	@echo NASM $@
	@$(NASM) $< -f elf -o $(OUTPUT_DIR)$@

%.bin: %.asm
	@echo NASM $@
	@$(NASM) $< -f bin -o $(OUTPUT_DIR)$@

clean:
	@rm -Rf $(OUTPUT_DIR)*
	@echo "CLEAN"

run: ArtichOS.bin
	$(QEMU) -drive format=raw,file=$(OUTPUT_DIR)$<,index=0,if=floppy

# Doesn't work atm idk why
run_debug: ArtichOS.bin kernel.elf
	$(QEMU) -s -drive format=raw,file=$(OUTPUT_DIR)$<,index=0,if=floppy &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file $(OUTPUT_DIR)kernel.elf"

prebuild:
	@mkdir -p $(foreach dir, $(src_dir), $(OUTPUT_DIR)$(dir))
