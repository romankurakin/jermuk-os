const std = @import("std");
const builtin = @import("builtin");

pub const Arch = enum {
    aarch64,

    pub fn current() Arch {
        return switch (builtin.cpu.arch) {
            .aarch64 => .aarch64,
            else => @compileError("Unsupported architecture"),
        };
    }
};
