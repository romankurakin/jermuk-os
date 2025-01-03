const Cpu = @import("../../../cpu/interface.zig").Cpu;

pub fn impl() Cpu {
    comptime {
        return .{
            .waitForever = waitForever,
        };
    }
}

fn waitForever() noreturn {
    while (true) {
        asm volatile ("wfi");
    }
}
