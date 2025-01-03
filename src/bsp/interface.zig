pub const Board = struct {
    name: []const u8,
    init: *const fn () BoardError!void,
};

pub const BoardError = error{
    InitializationFailed,
};
