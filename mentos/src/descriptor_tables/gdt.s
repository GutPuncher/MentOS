#                MentOS, The Mentoring Operating system project
# @file   gdt.asm
# @brief
# @copyright (c) 2014-2021 This file is distributed under the MIT License.
# See LICENSE.md for details.

.global gdt_flush       # Allows the C code to call gdt_flush().

# -----------------------------------------------------------------------------
# SECTION (text)
# -----------------------------------------------------------------------------
.text

gdt_flush: 
    mov 4(%esp),%eax # Get the pointer to the GDT, passed as a parameter.
    lgdt (%eax)

    # The data segments selectors (registers), can be easily modified using
    # simple mov instruction, but the cs can't be used with mov, so you use:
    mov $0x10,%ax   # 0x10 is the offset in the GDT to our data segment
    mov %ax,%ds     # Load all data segment selectors
    mov %ax,%es
    mov %ax,%fs
    mov %ax,%gs
    mov %ax,%ss
    
    # to load the segment configurations into the the code segment selector.
    ret
