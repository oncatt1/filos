TARGET = kernel
BUILD = build
SRC = kernel/kernel.cpp
OBJ = $(BUILD)/kernel.o
ISO = $(BUILD)/filos.iso

CXX = g++
CXXFLAGS = -ffreestanding -Wall -Wextra -fno-exceptions -fno-rtti -m32
LD = ld
LDFLAGS = -T kernel/linker.ld -m elf_i386

.PHONY: all run clean

all: $(ISO)

$(BUILD):
	mkdir -p $(BUILD)

$(OBJ): $(SRC) | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD)/kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(ISO): $(BUILD)/kernel.bin
	mkdir -p $(BUILD)/iso/boot/grub
	cp $< $(BUILD)/iso/boot/kernel
	cp grub/grub.cfg $(BUILD)/iso/boot/grub/
	grub-mkrescue -o $@ $(BUILD)/iso

run: $(ISO)
	bochs -f bochsrc.txt

clean:
	rm -rf $(BUILD)
