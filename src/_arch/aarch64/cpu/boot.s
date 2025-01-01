.section .text.boot_entry
.global _start

_start:
    // Initialize system registers for EL3->EL1 transition
    mrs     x0, CurrentEL       // Check current exception level
    and     x0, x0, #12
    cmp     x0, #12
    bne     hang

    // Setup for EL3 to EL1 transition
    mov     x0, #(1 << 31)
    msr     hcr_el2, x0        // Set up HCR_EL2
    
    mov     x0, #0x33ff
    msr     cptr_el3, x0       // Configure CPTR_EL3
    msr     cptr_el2, x0       // Configure CPTR_EL2

    mov     x0, #0x431     
    msr     scr_el3, x0        // Set up SCR_EL3

    mov     x0, #5
    msr     spsr_el3, x0       // Set up SPSR_EL3

    adr     x0, el1_entry      // Get el1_entry address
    msr     elr_el3, x0        // Set up where to jump after ERET

    // Clear frame and link registers before ERET
    mov     x29, xzr
    mov     x30, xzr
    
    eret                       // Switch to EL1

el1_entry:
    // Set up stack pointer
    adr     x5, _start
    add     x5, x5, #0x10000
    and     x5, x5, #~15       // Ensure 16-byte alignment
    mov     sp, x5

    // Clear frame/link again after el1 entry
    mov     x29, xzr
    mov     x30, xzr
    
    bl      main               // Jump to Zig code

hang:
    wfe                        // Power-saving wait
    b       hang               // Loop forever