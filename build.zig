const std = @import("std");

const Board = enum {
    raspi4b,
    raspi5,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .aarch64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });
    const optimize = b.standardOptimizeOption(.{});

    inline for (comptime std.enums.values(Board)) |board| {
        const exe = b.addExecutable(.{
            .name = @tagName(board),
            .target = target,
            .optimize = optimize,
            .link_libc = false,
            .single_threaded = true,
            .root_source_file = .{ .cwd_relative = "src/main.zig" },
        });

        const base_ld_path = "src/_arch/bsp/raspberrypi";
        const ld_script = switch (board) {
            .raspi4b => base_ld_path ++ "/raspi4b/kernel.ld",
            .raspi5 => base_ld_path ++ "/raspi5/kernel.ld",
        };

        exe.setLinkerScript(.{ .cwd_relative = ld_script });
        exe.addAssemblyFile(.{ .cwd_relative = "src/_arch/aarch64/cpu/boot.s" });

        const install = b.addInstallArtifact(exe, .{
            .dest_sub_path = b.fmt("boards/{s}/kernel8.img", .{@tagName(board)}),
        });
        b.getInstallStep().dependOn(&install.step);
    }
}
