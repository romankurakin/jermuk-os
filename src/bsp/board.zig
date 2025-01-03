const build_options = @import("build_options");
const board_type = @import("../board_type.zig");

pub const Board = board_type.Board;

pub fn current() Board {
    return @as(Board, @enumFromInt(build_options.board_raw));
}
