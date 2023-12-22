#                MentOS, The Mentoring Operating system project
# @file   interrupt.asm
# @brief
# @copyright (c) 2014-2021 This file is distributed under the MIT License.
# See LICENSE.md for details.

.extern irq_handler

.macro IRQ ARG1, ARG2
    .globl IRQ_&ARG1
    IRQ_&ARG1:
        cli # disable interrupt line
        push $0
        push &ARG2
        jmp irq_common
.endm

# -----------------------------------------------------------------------------
# SECTION (text)
# -----------------------------------------------------------------------------
.text

# 32 is the first irq, 47 is the last one. DO NOT CHANGE THESE NUMBERS. 
IRQ 0, 32
IRQ 1, 33
IRQ 2, 34
IRQ 3, 35
IRQ 4, 36
IRQ 5, 37
IRQ 6, 38
IRQ 7, 39
IRQ 8, 40
IRQ 9, 41
IRQ 10, 42
IRQ 11, 43
IRQ 12, 44
IRQ 13, 45
IRQ 14, 46
IRQ 15, 47

irq_common: 
    # ==== Save CPU registers ===================================================
    # when an irq occurs, the following registers are already pushed on stack:
    # eip, cs, eflags, useresp, ss

    # Save registers: eax, ecx, edx, ebx, esp, ebp, esi, edi
    pusha

    # Save segment registers
    push %ds
    push %es
    push %fs
    push %gs
    # ---------------------------------------------------------------------------

    # ==== ensure we are using kernel data segment ==============================
    mov $0x10,%ax
    mov %ax,%ds
    mov %ax,%es
    mov %ax,%fs
    mov %ax,%gs
    cld
    # ---------------------------------------------------------------------------

    # ==== Call the interrupt handler ===========================================
    # The argument passed is a pointer to an Interrupt_State struct,
    # which describes the stack layout for all interrupts.
    push   %esp
    call    irq_handler
    add    $0x04, %esp        # remove esp from stack
    # ---------------------------------------------------------------------------

    # ==== Restore registers ====================================================
    # restore segment registers
    pop %gs
    pop %fs
    pop %es
    pop %ds

    # restore registers: eax, ecx, edx, ebx, esp, ebp, esi, edi
    popa
    # ---------------------------------------------------------------------------

    # Cleanup error code and IRQ #
    add $0x08, %esp

    # return to process
    iret                        # pops 5 things at once:
                                #   CS, EIP, EFLAGS, SS, and ESP
