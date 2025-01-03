const cpu = @import("cpu.zig");
const bsp = @import("bsp.zig");

export fn main() noreturn {
    kernelInit() catch {
        cpu.waitForever();
    };
}

fn kernelInit() !noreturn {
    try bsp.board.init();

    cpu.waitForever();
}
