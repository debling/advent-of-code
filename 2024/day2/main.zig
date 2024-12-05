const std = @import("std");

const inputData = @embedFile("input.txt");

// pub fn main() !void {
//     var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//     defer arena.deinit();
//     const alloc = arena.allocator();
//
//
//     const parsedInput = try parseInput(alloc, inputData);
//     //
//     // const part1 = try solve1(parsedInput);
//     // const part2 = try solve2(alloc, parsedInput);
//
//     // std.debug.print("Part 1: {}\n", .{part1});
//     // std.debug.print("Part 2: {}\n", .{part2});
// }
//
fn parseInput(alloc: std.mem.Allocator, input: []const u8) void {
    var tokenizer = std.mem.tokenizeSequence(u8, input, "\n");

    var levels = std.ArrayList(std.ArrayList(u32)).init(alloc);

    var currentLevel = std.ArrayList(u32).init(alloc);
    levels.append(currentLevel) catch unreachable;

    while (tokenizer.next()) |numSequence| {
        std.debug.print("Token: {s}", .{numSequence});
        for (numSequence) |seqItem| {
            switch (seqItem) {
                ' ' => continue,
                else => {
                    const n = seqItem - '0';
                    currentLevel.append(n) catch unreachable;
                },
            }

        }
    }
}

test "test with example input" {
    const input =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;

    const alloc = std.testing.allocator;

    parseInput(alloc, input);
}
