const std = @import("std");

const Alloc = std.mem.Allocator;

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
fn parseInput(alloc: std.mem.Allocator, input: []const u8) !*const []*const[]u32 {
    var lines = std.mem.splitScalar(u8, input, '\n');

    var reports = std.ArrayList(*const []u32).init(alloc);
    var currentReport = std.ArrayList(u32).init(alloc);

    while (lines.next()) |numSequence| {
        std.debug.print("Line {any} \n", .{numSequence});
        for (numSequence) |seqItem| {
            switch (seqItem) {
                ' ' => continue,
                else => {
                    const n = seqItem - '0';
                    try currentReport.append(n); 
                },
            }
        }

        try reports.append(&(try currentReport.toOwnedSlice()));
    }

    const out = try reports.toOwnedSlice(); 
    return &out;
}

fn isReportSafe(report: *const []u32) bool {
    std.debug.assert(report.*.len > 1);

    var idx: u8 = 1;
    while (idx < report.*.len) : (idx += 1) {
        const fst: i32 = @intCast(report.*[idx - 1]);
        const snd: i32 = @intCast(report.*[idx]);

        const diff: i32 = fst - snd;
        if (@abs(diff) > 2) {
            return false;
        }
    }

    return true;
}


fn solvePart1(reports: *const[]*const[]u32) void {
    var safeCount: u32 = 0;
    for (reports.*) |l| {
        std.debug.print("report {any}\n", .{l.*});
        const isSafe: u1 = @bitCast(isReportSafe(l));
        safeCount +=  @intCast(isSafe);
    }
    
    std.debug.print("Part 1: {}", .{safeCount});
}

pub fn main() !void {
    const arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const reports = try parseInput(alloc, inputData);

    solvePart1(reports);
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
    const reports = try parseInput(alloc, input);
    defer alloc.free(reports.*);
    defer for (reports.*) |r| {
        alloc.free(r.*);
    };

    solvePart1(reports);
}
