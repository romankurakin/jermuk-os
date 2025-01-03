const Board = @import("../interface.zig").Board;
const BoardError = @import("../interface.zig").BoardError;

fn init() BoardError!void {
    return;
}

pub fn impl() Board {
    return .{
        .name = "Raspberry Pi",
        .init = init,
    };
}
