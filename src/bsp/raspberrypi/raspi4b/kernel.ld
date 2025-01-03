/* Physical memory starts at 0x0 */
__rpi_phys_dram_start_addr = 0x0;

/* Kernel loads at 0x80000 (required by Raspberry Pi bootloader) */
__rpi_phys_binary_load_addr = 0x80000;

ENTRY(_start)

SECTIONS
{
    /* Start at the required load address */
    . = __rpi_phys_binary_load_addr;

    /* Boot code section must be first */
    .text.boot : {
        *(.text.boot_entry)     /* Boot entry point code */
    }

    /* Main code section */
    .text : ALIGN(8) {
        *(.text .text.*)        /* All other code */
    }

    /* Read-only data */
    .rodata : ALIGN(8) {
        *(.rodata .rodata.*)    /* Constants and strings */
    }

    /* Initialized data */
    .data : ALIGN(8) {
        __data_start = .;
        *(.data .data.*)
        . = ALIGN(8);
        __data_end = .;
    }

    /* Zero-initialized data (cleared at boot) */
    .bss (NOLOAD) : ALIGN(16) {
        . = ALIGN(16);          /* Align for efficient zeroing */
        __bss_start = .;
        *(.bss .bss.* .sbss .sbss.*)
        *(COMMON)
        . = ALIGN(16);
        __bss_end = .;
    }

    /* Stack section - place after BSS */
    .stack (NOLOAD) : ALIGN(16) {
        __stack_start = .;
        . = . + 0x10000;        /* 64KB of stack space */
        . = ALIGN(16);          /* Ensure end is aligned */
        __stack_end = .;
    }

    /* Discard unnecessary sections */
    /DISCARD/ : {
        *(.comment)             /* Comment section */
        *(.gnu*)               /* GNU-specific data */
        *(.note*)              /* Note sections */
        *(.eh_frame*)          /* Exception unwinding */
        *(.note.GNU-stack)     /* Stack markings */
    }
}
