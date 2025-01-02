pub fn wait_forever() noreturn {
    while (true) {
        asm volatile ("wfe");
    }
}

pub const BOOT_CORE_ID = 0;

pub const CORE_ID_MASK = 0b11;

comptime {
    asm (
        \\.global BOOT_CORE_ID
        \\.global CORE_ID_MASK
    );
}
