BUILD_DIR := build
BOOT_DIR := boot

QEMU := qemu-system-i386
QEMU += -drive file=$(BUILD_DIR)/floppy_exp.img,if=floppy,index=0,format=raw

ASM := nasm -f bin
INCLUDE_ASM := -I lib/libasm

CC := gcc
CFLAGS := -ffreestanding -Wall -Werror -pedantic 

.PHONY: floppy boot clean all run

floppy: $(BUILD_DIR)/floppy_exp.img

$(BUILD_DIR)/floppy_exp.img: boot
	dd if=/dev/zero of=$(BUILD_DIR)/floppy_exp.img bs=512 count=2880
	mkfs.fat -F 12 -n "KALZ" $(BUILD_DIR)/floppy_exp.img
	dd if=$(BUILD_DIR)/boot.bin of=$(BUILD_DIR)/floppy_exp.img conv=notrunc
	mcopy -i $(BUILD_DIR)/floppy_exp.img lib/libasm/test.bin "::test.bin"

boot: $(BUILD_DIR)/boot.bin

$(BUILD_DIR)/boot.bin: $(BOOT_DIR)/boot.s
	$(ASM) $(INCLUDE_ASM) -o $(BUILD_DIR)/boot.bin boot/boot.s

all: boot floppy
	$(QEMU)

run: boot
	$(QEMU)

clean:
	rm -rf $(BUILD_DIR)/*	
