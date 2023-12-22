#                MentOS, The Mentoring Operating system project
# @file boot.asm
# @brief Kernel start location, multiboot header
# @copyright (c) 2014-2021 This file is distributed under the MIT License.
# See LICENSE.md for details.

                    # All instructions should be 32-bit.
.extern boot_main   # The start point of our C code

# The magic field should contain this.
.equ                       MULTIBOOT_HEADER_MAGIC, 0x1BADB002
# This should be in %eax.
.equ                       MULTIBOOT_BOOTLOADER_MAGIC, 0x2BADB002

# = Specify what GRUB should PROVIDE =========================================
# Align the kernel and kernel modules on i386 page (4KB) boundaries.
.equ                  MULTIBOOT_PAGE_ALIGN, 0x00000001
# Provide the kernel with memory information.
.equ                  MULTIBOOT_MEMORY_INFO, 0x00000002
# Must pass video information to OS.
.equ                  MULTIBOOT_VIDEO_MODE, 0x00000004
# -----------------------------------------------------------------------------

# This is the flag combination that we prepare for Grub
# to read at kernel load time.
.equ MULTIBOOT_HEADER_FLAGS, (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)
# Grub reads this value to make sure it loads a kernel
# and not just garbage.
.equ MULTIBOOT_CHECKSUM, -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

.equ                LOAD_MEMORY_ADDRESS, 0x00000000
# reserve (1024*1024) for the stack on a doubleword boundary
.equ                KERNEL_STACK_SIZE, 0x100000

# -----------------------------------------------------------------------------
# SECTION (multiboot_header)
# -----------------------------------------------------------------------------
.globl multiboot_header
.align 4
# This is the GRUB Multiboot header.
multiboot_header: 
    # magic
    .quad MULTIBOOT_HEADER_MAGIC
    # flags
    .quad MULTIBOOT_HEADER_FLAGS
    # checksum
    .quad MULTIBOOT_CHECKSUM

# -----------------------------------------------------------------------------
# SECTION (data)
# -----------------------------------------------------------------------------
# section .data nobits
# align 4096

# -----------------------------------------------------------------------------
# SECTION (text)
# -----------------------------------------------------------------------------
.text
.global boot_entry
boot_entry: 
    # Clear interrupt flag [IF = 0]; 0xFA
    cli
    # To set up a stack, we simply set the esp register to point to the top of
    # our stack (as it grows downwards).
    mov $stack_top, %esp
    # pass the initial ESP
    push %esp
    # pass Multiboot info structure
    push %ebx
    # pass Multiboot magic number
    push %eax
    # Call the boot_main() function inside boot.c
    call boot_main
    # Set interrupt flag [IF = 1]; 0xFA
    # Clear interrupts and hang if we return from boot_main
    cli
hang: 
    hlt
    jmp hang

.global boot_kernel
boot_kernel: 
    mov 4(%esp),%edx  # stack_pointer
    mov 8(%esp),%ebx  # entry
    mov 12(%esp),%eax  # boot info
    mov %edx,%esp # set stack pointer
    push %eax # push the boot info
    call *%ebx # call the kernel main


# -----------------------------------------------------------------------------
# SECTION (bss)
# -----------------------------------------------------------------------------
.global stack_bottom
.global stack_top
.bss
.align 16
stack_bottom: 
    .skip KERNEL_STACK_SIZE
stack_top: 
    # the top of the stack is the bottom because the stack counts down

