/* kernel/kernel.cpp */
#define MULTIBOOT_HEADER_MAGIC 0x1BADB002
#define MULTIBOOT_HEADER_FLAGS 0x0
#define MULTIBOOT_CHECKSUM -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

extern "C" {
    // Multiboot header
    __attribute__((section(".multiboot")))
    const unsigned int multiboot_header[] = {
        MULTIBOOT_HEADER_MAGIC,
        MULTIBOOT_HEADER_FLAGS,
        MULTIBOOT_CHECKSUM
    };

    void kernel_main() {
        const char* msg = "Welcome to Filos OS!";
        char* vga = (char*)0xb8000; // VGA text buffer

        for (int i = 0; msg[i] != '\0'; ++i) {
            vga[i * 2] = msg[i];     // Character
            vga[i * 2 + 1] = 0x0F;   // Attribute (white text on black)
        }

        while (1) {
            asm volatile ("hlt"); // Halt CPU
        }
    }
}