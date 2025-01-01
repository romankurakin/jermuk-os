const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .aarch64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "kernel8.img",
        .target = target,
        .optimize = optimize,
        .link_libc = false,
        .single_threaded = true,
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
    });

    const linker_script = .{
        .cwd_relative = "src/_arch/bsp/raspberrypi/kernel.ld",
    };
    exe.setLinkerScript(linker_script);

    const asm_file = .{
        .cwd_relative = "src/_arch/aarch64/cpu/boot.s",
    };
    exe.addAssemblyFile(asm_file);

    b.installArtifact(exe);
}
