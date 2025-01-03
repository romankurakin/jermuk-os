const std = @import("std");
const Board = @import("src/board_type.zig").Board;

pub fn build(b: *std.Build) void {
    const selected_board = b.option(Board, "board", "Select target board (raspi4b, raspi5)") orelse .raspi4b;

    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .aarch64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    const options = b.addOptions();
    options.addOption(u1, "board_raw", @intFromEnum(selected_board));

    const exe = b.addExecutable(.{
        .name = @tagName(selected_board),
        .target = target,
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
        .optimize = optimize,
        .link_libc = false,
        .single_threaded = true,
    });

    exe.root_module.addOptions("build_options", options);

    const ld_path = switch (selected_board) {
        .raspi4b => "src/bsp/raspberrypi/raspi4b/kernel.ld",
        .raspi5 => "src/bsp/raspberrypi/raspi5/kernel.ld",
    };
    exe.setLinkerScript(.{ .cwd_relative = ld_path });
    exe.addAssemblyFile(.{ .cwd_relative = "src/_arch/aarch64/cpu/boot.s" });

    const artifact = b.addInstallArtifact(exe, .{
        .dest_sub_path = b.fmt("boards/{s}/kernel8.img", .{@tagName(selected_board)}),
    });
    b.getInstallStep().dependOn(&artifact.step);
}
