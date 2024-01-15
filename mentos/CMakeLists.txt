# =============================================================================
# Set the main file names.
set(KERNEL_NAME       kernel)
set(BOOTLOADER_NAME   kernel_bootloader)
set(BUDDY_SYSTEM_NAME kernel_memory)
set(BUDDY_SYSTEM_FILE ${CMAKE_CURRENT_SOURCE_DIR}/src/mem/libbuddysystem.a)

# =============================================================================
# OPTIONS
# =============================================================================

# Add the memory option.
option(USE_BUDDY_SYSTEM "Build using the buddysystem written by the user." OFF)
# Enables cache tracing.
option(ENABLE_CACHE_TRACE "Enables cache tracing." OFF)
# Enables memory allocation tracing.
option(ENABLE_ALLOC_TRACE "Enables memory allocation tracing." OFF)
# Enables scheduling feedback on terminal.
option(ENABLE_SCHEDULER_FEEDBACK "Enables scheduling feedback on terminal." OFF)

# =============================================================================
# SOURCES
# =============================================================================

# Define the list of files.
set(KERNEL_SOURCES
    ${PROJECT_SOURCE_DIR}/mentos/src/kernel.c
    ${PROJECT_SOURCE_DIR}/mentos/src/multiboot.c
    ${PROJECT_SOURCE_DIR}/mentos/src/devices/pci.c
    ${PROJECT_SOURCE_DIR}/mentos/src/devices/fpu.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/ata.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/rtc.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/fdc.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/mouse.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/ps2.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/keyboard/keyboard.c
    ${PROJECT_SOURCE_DIR}/mentos/src/drivers/keyboard/keymap.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/vfs.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/read_write.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/open.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/stat.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/readdir.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/procfs.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/ioctl.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/namei.c
    ${PROJECT_SOURCE_DIR}/mentos/src/fs/ext2.c
    ${PROJECT_SOURCE_DIR}/mentos/src/hardware/timer.c
    ${PROJECT_SOURCE_DIR}/mentos/src/hardware/cpuid.c
    ${PROJECT_SOURCE_DIR}/mentos/src/hardware/pic8259.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/debug.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/mm_io.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/video.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/stdio.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/proc_video.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/proc_running.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/proc_feedback.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/proc_system.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/proc_ipc.c
    ${PROJECT_SOURCE_DIR}/mentos/src/io/vga/vga.c
    ${PROJECT_SOURCE_DIR}/mentos/src/ipc/ipc.c
    ${PROJECT_SOURCE_DIR}/mentos/src/ipc/msg.c
    ${PROJECT_SOURCE_DIR}/mentos/src/ipc/sem.c
    ${PROJECT_SOURCE_DIR}/mentos/src/ipc/shm.c
    ${PROJECT_SOURCE_DIR}/mentos/src/kernel/sys.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/assert.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/ctype.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/mutex.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/string.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/vsprintf.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/vscanf.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/time.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/libgen.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/strerror.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/math.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/fcvt.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/spinlock.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/stdlib.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/rbtree.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/ndtree.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/hashmap.c
    ${PROJECT_SOURCE_DIR}/mentos/src/klib/list.c
    ${PROJECT_SOURCE_DIR}/mentos/src/mem/kheap.c
    ${PROJECT_SOURCE_DIR}/mentos/src/mem/paging.c
    ${PROJECT_SOURCE_DIR}/mentos/src/mem/slab.c
    ${PROJECT_SOURCE_DIR}/mentos/src/mem/vmem_map.c
    ${PROJECT_SOURCE_DIR}/mentos/src/mem/zone_allocator.c
    ${PROJECT_SOURCE_DIR}/mentos/src/elf/elf.c
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/gdt.c
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/gdt.s
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/interrupt.c
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/exception.c
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/interrupt.s
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/exception.s
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/idt.c
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/idt.s
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/tss.c
    ${PROJECT_SOURCE_DIR}/mentos/src/descriptor_tables/tss.s
    ${PROJECT_SOURCE_DIR}/mentos/src/process/scheduler_algorithm.c
    ${PROJECT_SOURCE_DIR}/mentos/src/process/scheduler_feedback.c
    ${PROJECT_SOURCE_DIR}/mentos/src/process/scheduler.c
    ${PROJECT_SOURCE_DIR}/mentos/src/process/process.c
    ${PROJECT_SOURCE_DIR}/mentos/src/process/wait.c
    ${PROJECT_SOURCE_DIR}/mentos/src/process/user.s
    ${PROJECT_SOURCE_DIR}/mentos/src/sys/utsname.c
    ${PROJECT_SOURCE_DIR}/mentos/src/sys/module.c
    ${PROJECT_SOURCE_DIR}/mentos/src/system/errno.c
    ${PROJECT_SOURCE_DIR}/mentos/src/system/panic.c
    ${PROJECT_SOURCE_DIR}/mentos/src/system/printk.c
    ${PROJECT_SOURCE_DIR}/mentos/src/system/signal.c
    ${PROJECT_SOURCE_DIR}/mentos/src/system/syscall.c
)

# =============================================================================
# Add kernel library.
if(USE_BUDDY_SYSTEM)
    # Add the library with `buddysystem.c`.
    add_library(${KERNEL_NAME} ${KERNEL_SOURCES} ${CMAKE_CURRENT_SOURCE_DIR}/src/mem/buddysystem.c)
else(USE_BUDDY_SYSTEM)
    # Add the library without `buddysystem.c`.
    add_library(${KERNEL_NAME} ${KERNEL_SOURCES})
    # Link the exercise libraries.
    target_link_libraries(${KERNEL_NAME} ${BUDDY_SYSTEM_FILE})
endif(USE_BUDDY_SYSTEM)
# Add the includes.
target_include_directories(
    ${KERNEL_NAME} PUBLIC
    ${CMAKE_SOURCE_DIR}/mentos/inc
    ${CMAKE_SOURCE_DIR}/libc/inc
)
# Define that this code is kernel code.
target_compile_definitions(
    ${KERNEL_NAME} PUBLIC
    __KERNEL__
)
# Link the kernel.
add_custom_target(
    ${KERNEL_NAME}.bin
    COMMAND ${CMAKE_LINKER} -melf_i386 -static --oformat elf32-i386 --output ${KERNEL_NAME}.bin --script ${CMAKE_CURRENT_SOURCE_DIR}/kernel.lds -Map ${KERNEL_NAME}.map -u kmain
            $<TARGET_FILE_NAME:${KERNEL_NAME}> ${BUDDY_SYSTEM_FILE}
    COMMAND objcopy -I binary -O elf32-i386 -B i386 ${KERNEL_NAME}.bin ${KERNEL_NAME}.bin.o
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/kernel.lds
    DEPENDS ${KERNEL_NAME}
    BYPRODUCTS ${KERNEL_NAME}.bin ${KERNEL_NAME}.bin.o
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

# =============================================================================
# Enables cache tracing.
if(ENABLE_CACHE_TRACE)
    target_compile_definitions(${KERNEL_NAME} PUBLIC ENABLE_CACHE_TRACE)
endif(ENABLE_CACHE_TRACE)

# =============================================================================
# Enables memory allocation tracing.
if(ENABLE_ALLOC_TRACE)
    target_compile_definitions(${KERNEL_NAME} PUBLIC ENABLE_ALLOC_TRACE)
endif(ENABLE_ALLOC_TRACE)

# =============================================================================
# Enables scheduling feedback on terminal.
if(ENABLE_SCHEDULER_FEEDBACK)
    target_compile_definitions(${KERNEL_NAME} PUBLIC ENABLE_SCHEDULER_FEEDBACK)
endif(ENABLE_SCHEDULER_FEEDBACK)

# =============================================================================
# Set the list of valid scheduling options.
set(SCHEDULER_TYPES SCHEDULER_RR SCHEDULER_PRIORITY SCHEDULER_CFS SCHEDULER_EDF SCHEDULER_RM SCHEDULER_AEDF)
# Add the scheduling option.
set(SCHEDULER_TYPE "SCHEDULER_RR" CACHE STRING "Chose the type of scheduler: ${SCHEDULER_TYPES}")
# List of schedulers.
set_property(CACHE SCHEDULER_TYPE PROPERTY STRINGS ${SCHEDULER_TYPES})
# Check which scheduler is currently active and export the related macro.
list(FIND SCHEDULER_TYPES ${SCHEDULER_TYPE} INDEX)
if(index EQUAL -1)
    message(FATAL_ERROR "Scheduler type ${SCHEDULER_TYPE} is not valid.")
else()
    # Add the define stating which scheduler is currently active.
    target_compile_definitions(${KERNEL_NAME} PUBLIC ${SCHEDULER_TYPE})
    # Notify the type of scheduler.
    message(STATUS "Setting scheduler type to ${SCHEDULER_TYPE}.")
endif()

# =============================================================================
# Set the list of valid video driver options.
set(VIDEO_TYPES VGA_TEXT_MODE VGA_MODE_320_200_256 VGA_MODE_640_480_16 VGA_MODE_720_480_16)
# Add the video driver option.
set(VIDEO_TYPE "VGA_TEXT_MODE" CACHE STRING "Chose the type of video driver: ${VIDEO_TYPES}")
# List of video tpes.
set_property(CACHE VIDEO_TYPE PROPERTY STRINGS ${VIDEO_TYPES})
# Check which video driver is currently active and export the related macro.
list(FIND VIDEO_TYPES ${VIDEO_TYPE} INDEX)
if(index EQUAL -1)
    message(FATAL_ERROR "Video type ${VIDEO_TYPE} is not valid.")
else()
    # Add the define stating which video driver is currently active.
    target_compile_definitions(${KERNEL_NAME} PUBLIC ${VIDEO_TYPE})
    # Notify the type of video driver.
    message(STATUS "Setting vide type to ${VIDEO_TYPE}.")
endif()

# =============================================================================
# Set the list of valid keyboard mappings.
set(KEYMAP_TYPES KEYMAP_US KEYMAP_IT)
# Add the keyboard mapping.
set(KEYMAP_TYPE "KEYMAP_US" CACHE STRING "Chose the type of keyboard mapping: ${KEYMAP_TYPES}")
# List of keyboard mappings.
set_property(CACHE KEYMAP_TYPE PROPERTY STRINGS ${KEYMAP_TYPES})
# Check which keyboard mapping is currently active and export the related macro.
list(FIND KEYMAP_TYPES ${KEYMAP_TYPE} INDEX)
if(index EQUAL -1)
    message(FATAL_ERROR "keyboard mapping ${KEYMAP_TYPE} is not valid.")
else()
    # Add the define stating which keyboard mapping is currently active.
    target_compile_definitions(${KERNEL_NAME} PUBLIC USE_${KEYMAP_TYPE})
    # Notify the type of keyboard mapping.
    message(STATUS "Setting keyboard mapping to ${KEYMAP_TYPE}.")
endif()

# =============================================================================
# Add bootloader library.
add_library(
    ${BOOTLOADER_NAME}
    ${CMAKE_CURRENT_SOURCE_DIR}/src/boot.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/boot.s
)
# Add the includes.
target_include_directories(
    ${BOOTLOADER_NAME} PUBLIC
    ${CMAKE_SOURCE_DIR}/mentos/inc
    ${CMAKE_SOURCE_DIR}/libc/inc
)
# Define that this code is kernel code.
target_compile_definitions(
    ${BOOTLOADER_NAME} PUBLIC
    __KERNEL__
)
add_dependencies(
    ${BOOTLOADER_NAME}
    ${KERNEL_NAME}
)
target_link_libraries(
    ${BOOTLOADER_NAME} PUBLIC
    ${KERNEL_NAME}
)
# Link the bootloader.
add_custom_target(
    ${BOOTLOADER_NAME}.bin
    COMMAND ${CMAKE_LINKER} -melf_i386 -static --output ${BOOTLOADER_NAME}.bin --script ${CMAKE_CURRENT_SOURCE_DIR}/boot.lds -Map ${BOOTLOADER_NAME}.map ${KERNEL_NAME}.bin.o $<TARGET_FILE_NAME:${BOOTLOADER_NAME}>
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/boot.lds
    DEPENDS ${BOOTLOADER_NAME}
    DEPENDS ${KERNEL_NAME}.bin
    BYPRODUCTS ${BOOTLOADER_NAME}.bin
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
