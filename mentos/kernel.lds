OUTPUT_FORMAT("elf32-i386")

ENTRY(kmain)

MEMORY {
	USER_SPACE : ORIGIN = 0x00000000, LENGTH = 3072M
	KERNEL_LOWMEM : ORIGIN = 0xC0000000, LENGTH = 896M
	KERNEL_HIGHMEM : ORIGIN = 0xF8000000, LENGTH = 128M
}


SECTIONS
{
	. = 0xC0000000;
    /* Put the .text section. */
    .text . : AT(ADDR(.text))
    {
        EXCLUDE_FILE(*boot.*.o) *(.text)
    } > KERNEL_LOWMEM

    /* Read-only data. */
    .rodata ALIGN(4K) : AT(ADDR(.rodata))
    {
        EXCLUDE_FILE(*boot.*.o) *(.rodata)
    } > KERNEL_LOWMEM

    /* Read-write data (initialized) */
    .data   ALIGN(4K) : AT(ADDR(.data))
    {
        EXCLUDE_FILE(*boot.*.o) *(.data)
    } > KERNEL_LOWMEM

    /* Read-write data (uninitialized) and stack */
    .bss    ALIGN(4K) : AT(ADDR(.bss))
    {
        *(.bss*)
    } > KERNEL_LOWMEM

    /* Put a symbol end here, it tells us where all the kernel code/data ends,
       it means everything after 'end' can be used for something else. */
    _kernel_end = .;
}
