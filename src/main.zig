const std = @import("std");
const cpu = @import("cpu.zig");
const bsp = @import("bsp.zig");

export fn main() noreturn {
    kernel_init();
}

pub fn kernel_init() noreturn {
    cpu.wait_forever();
}
