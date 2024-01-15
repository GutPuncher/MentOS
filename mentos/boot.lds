OUTPUT_FORMAT("elf32-i386")

ENTRY(boot_entry)

MEMORY {
	BOOTLOADER_MEM : ORIGIN = 0x00000000, LENGTH = 128M
}

SECTIONS
{
	. = 0x00100000;
	
    _bootloader_start = .;

	.multiboot . : AT(ADDR(.multiboot))
	{
		. = ALIGN(4);
		*(.multiboot_header)
	} > BOOTLOADER_MEM

    /* Put the .text section. */
    .text . : AT(ADDR(.text))
    {
        *(.text)
    } > BOOTLOADER_MEM

    /* Read-only data. */
    .rodata ALIGN(4K) : AT(ADDR(.rodata))
    {
        *(.rodata)
    } > BOOTLOADER_MEM

    /* Read-write data (initialized) */
    .data ALIGN(4K) : AT(ADDR(.data))
    {
        *(.data)
    } > BOOTLOADER_MEM

    /* Read-write data (uninitialized) and stack */
    .bss ALIGN(4K) : AT(ADDR(.bss))
    {
        *(.bss*)
    } > BOOTLOADER_MEM

    /* Put a symbol end here, it tells us where all the kernel code/data ends,
       it means everything after 'end' can be used for something else. */
    _bootloader_end = .;
}
