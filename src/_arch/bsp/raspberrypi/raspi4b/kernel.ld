ENTRY(_start)

SECTIONS
{
    . = 0x80000;
    .text.boot : {
        KEEP(*(.text.boot_entry))
    }
    
    .text : {
        *(.text*)
    }

    . = ALIGN(8);
    .rodata : {
        *(.rodata*)
    }

    . = ALIGN(8);
    .data : {
        *(.data*)
    }

    . = ALIGN(8);
    .bss : {
        *(.bss*)
        *(COMMON)
    }
}