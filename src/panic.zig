const std = @import("std");

pub fn handlePanic(msg: []const u8, trace: ?*std.builtin.StackTrace) noreturn {
    while (true) {}
}
