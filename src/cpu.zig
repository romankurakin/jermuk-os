const arch = @import("arch.zig");
const Cpu = @import("cpu/interface.zig").Cpu;

pub const cpu = blk: {
    const implementation = switch (arch.Arch.current()) {
        .aarch64 => @import("_arch/aarch64/cpu/impl.zig").impl(),
    };
    break :blk implementation;
};

pub const waitForever = cpu.waitForever;
