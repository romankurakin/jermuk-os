const board_type = @import("bsp/board.zig");
const Board = @import("bsp/interface.zig").Board;

pub const board = blk: {
    const implementation = switch (board_type.current()) {
        .raspi4b, .raspi5 => @import("bsp/raspberrypi/impl.zig").impl(),
    };
    break :blk implementation;
};
