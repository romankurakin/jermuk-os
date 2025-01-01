    .section .text.boot_entry
    .globl _start

_start:
1:
    wfe
    b 1b