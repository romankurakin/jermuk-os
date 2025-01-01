const std = @import("std");

pub export fn main() callconv(.C) noreturn {
    asm volatile (
        \\1:
        \\  wfe
        \\  b 1b
        ::: "memory");
    unreachable;
}

pub fn panic(msg: []const u8, error_return_trace: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    _ = msg;
    _ = error_return_trace;
    asm volatile (
        \\1:
        \\  wfe
        \\  b 1b
        ::: "memory");
    unreachable;
}
