const root = @import("root");
const arch_cpu = @import("../_arch/aarch64/cpu.zig");

export fn kernel_entry() callconv(.C) noreturn {
    arch_cpu.platform_init();
    root.kernel_init();
}
