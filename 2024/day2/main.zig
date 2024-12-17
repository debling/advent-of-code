const std = @import("std");

const inputData = @embedFile("input.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const parsedData = try parseInput(alloc, inputData);

    const part1 = solve1(parsedData);
    const part2 = solve2(parsedData);

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}

fn parseInput(alloc: std.mem.Allocator, input: []const u8) ![][]i32 {
    var splittedIn = std.mem.splitScalar(u8, input, '\n');

    var levels = std.ArrayList([]i32).init(alloc);

    while (splittedIn.next()) |numSequence| {
        if (numSequence.len == 0) {
            break;
        }
        var splittedReport = std.mem.tokenizeScalar(u8, numSequence, ' ');
        var currentReport = std.ArrayList(i32).init(alloc);
        while (splittedReport.next()) |seqItem| {
            const n = try std.fmt.parseInt(i32, seqItem, 10);
            try currentReport.append(n);
        }

        try levels.append(try currentReport.toOwnedSlice());
    }
    return levels.toOwnedSlice();
}

fn isSafe(report: []i32, tolerance: bool) bool {
    std.debug.assert(report.len > 1);

    const incrementDirection = std.math.sign(report[0] - report[1]);

    var levelRemoved = false;
    for (0..report.len - 1, 1..report.len) |fstIdx, sndIdx| {
        const diff = report[fstIdx] - report[sndIdx];
        const levelBad = (@abs(diff) > 3) or (incrementDirection != std.math.sign(diff));

        if (levelBad and !tolerance) {
            return false;
        } else if (levelBad and tolerance and !levelRemoved and sndIdx != report.len - 1) {
            const diffLvlRemoved = report[fstIdx] - report[sndIdx + 1];
            const levelStillBad = (@abs(diffLvlRemoved) > 3) or (incrementDirection != std.math.sign(diffLvlRemoved));

            if (levelStillBad) {
                return false;
            } else {
                levelRemoved = true;
            }
        }
    }

    return true;
}

fn solve1(input: [][]i32) u32 {
    var sum: u32 = 0;
    for (input) |r| {
        const reportSafe: u1 = @intFromBool(isSafe(r, false));
        sum += reportSafe;
    }
    return sum;
}

fn solve2(input: [][]i32) u32 {
    var sum: u32 = 0;
    for (input) |r| {
        const reportSafe: u1 = @intFromBool(isSafe(r, true));
        sum += reportSafe;
    }
    return sum;
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

    const parsedData = try parseInput(alloc, input);
    defer alloc.free(parsedData);
    defer for (parsedData) |value| {
        alloc.free(value);
    };

    try std.testing.expectEqual(true, isSafe(parsedData[0], false));
    try std.testing.expectEqual(false, isSafe(parsedData[1], false));
    try std.testing.expectEqual(false, isSafe(parsedData[2], false));
    try std.testing.expectEqual(false, isSafe(parsedData[3], false));
    try std.testing.expectEqual(false, isSafe(parsedData[4], false));
    try std.testing.expectEqual(true, isSafe(parsedData[5], false));

    try std.testing.expectEqual(2, solve1(parsedData));

    try std.testing.expectEqual(true, isSafe(parsedData[0], true));
    try std.testing.expectEqual(false, isSafe(parsedData[1], true));
    try std.testing.expectEqual(false, isSafe(parsedData[2], true));
    try std.testing.expectEqual(true, isSafe(parsedData[3], true));
    try std.testing.expectEqual(true, isSafe(parsedData[4], true));
    try std.testing.expectEqual(true, isSafe(parsedData[5], true));

    try std.testing.expectEqual(4, solve2(parsedData));
}
