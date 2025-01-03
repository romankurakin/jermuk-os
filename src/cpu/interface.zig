pub const Cpu = struct {
    /// Puts the CPU into a low-power wait state
    waitForever: *const fn () noreturn,
};
