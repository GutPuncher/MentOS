#                MentOS, The Mentoring Operating system project
# @file   tss.asm
# @brief
# @copyright (c) 2014-2021 This file is distributed under the MIT License.
# See LICENSE.md for details.

.global tss_flush

# -----------------------------------------------------------------------------
# SECTION (text)
# -----------------------------------------------------------------------------
.text

tss_flush: 
    mov $0x28,%ax
    ltr %ax
    ret

