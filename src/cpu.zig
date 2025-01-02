const arch_cpu = @import("_arch/aarch64/cpu.zig");

pub const wait_forever = arch_cpu.wait_forever;

pub const boot = @import("cpu/boot.zig");
