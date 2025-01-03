// This macro provides reliable PC-relative addressing for accessing symbols.
.macro ADR_REL register, symbol
    adrp    \register, \symbol            // Load page address
    add     \register, \register, #:lo12:\symbol  // Add page offset
.endm

// Boot entry point
.section .text.boot_entry
.global _start

_start:
    // Multicore systems boot all cores simultaneously
    // We need to ensure only core 0 runs the initialization
    mrs     x0, MPIDR_EL1                // Read Multiprocessor ID
    and     x0, x0, #3                   // Extract core ID (bottom 2 bits)
    cmp     x0, #0                       // Check if this is core 0
    b.ne    .L_parking_loop              // Park non-boot cores

    // Verify we're in EL3 before attempting EL transition
    mrs     x0, CurrentEL                // Read current Exception Level
    and     x0, x0, #12                  // Extract EL bits
    cmp     x0, #12                      // Check if we're in EL3 (12 = 0xC)
    b.ne    .L_parking_loop              // Park core if not in EL3

    // Set up EL3 to EL1 transition
    // First, configure EL2 (needed even though we'll bypass it)
    mov     x0, #(1 << 31)              // Set EL1 to AArch64
    msr     hcr_el2, x0                 // HCR_EL2 register

    // Enable FP/SIMD for all exception levels
    mov     x0, #0x33ff                 // All copro bits set
    msr     cptr_el3, x0                // Allow FP/SIMD in EL3
    msr     cptr_el2, x0                // Allow FP/SIMD in EL2

    // Configure Secure Configuration Register
    mov     x0, #0x431                  // Set execution state control
    msr     scr_el3, x0                 // Write SCR_EL3

    // Set up Saved Program Status Register for EL1
    mov     x0, #5                      // EL1_SP1 | D | A | I | F
    msr     spsr_el3, x0                // Exception return state

    // Set up exception return address
    adr     x0, el1_entry               // Load EL1 entry point
    msr     elr_el3, x0                 // Set return address

    // Clean up registers before transition
    mov     x29, xzr                    // Clear frame pointer
    mov     x30, xzr                    // Clear link register
    eret                                // Jump to EL1

.align 4                                // Ensure aligned entry
el1_entry:
    // Initialize BSS if it exists
    ADR_REL x0, __bss_start
    ADR_REL x1, __bss_end

    // Check if BSS section exists
    cmp     x0, x1
    b.eq    .L_stack_setup

.L_bss_init_loop:
    stp     xzr, xzr, [x0], #16         // Zero 16 bytes at a time
    cmp     x0, x1
    b.lo    .L_bss_init_loop            // Continue if more to zero

.L_stack_setup:
    // Set up the stack with proper alignment
    ADR_REL x5, __stack_end
    and     x5, x5, #~15                // Ensure 16-byte alignment
    mov     sp, x5

    // Clean up before jumping to Zig code
    mov     x29, xzr                    // Clear frame pointer
    mov     x30, xzr                    // Clear link register
    b       main                        // Jump to Zig main function

// Parking loop for non-boot cores or error conditions
.L_parking_loop:
    wfe                                 // Wait for event (power saving)
    b       .L_parking_loop             // Loop forever

// Add size and type information for debugging
.size   _start, . - _start