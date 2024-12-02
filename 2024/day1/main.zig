const std = @import("std");

const inputData = @embedFile("input.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();


    const parsedInput = try parseInput(alloc, inputData);

    const part1 = try solve1(parsedInput);
    const part2 = try solve2(alloc, parsedInput);

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});

}

fn parseInput(alloc: std.mem.Allocator, input: []const u8) ![2]*std.ArrayList(i32) {
    var list1 = std.ArrayList(i32).init(alloc);
    var list2 = std.ArrayList(i32).init(alloc);

    const lists = [2]*std.ArrayList(i32){&list1, &list2};

    var it = std.mem.tokenizeAny(u8, input, " \n" );

    var listChoice: u8 = 0;
    while (it.next()) |num| {
        const n = try std.fmt.parseInt(i32, num, 10);
        try lists[listChoice].append(n);
        listChoice = (listChoice + 1) % 2;
    }

    std.mem.sort(i32, list1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, list2.items, {}, std.sort.asc(i32));

    return lists;
}


pub fn solve1(input: [2]*std.ArrayList(i32)) !u32 {
    const list1 = input[0];
    const list2 = input[1];

    var count: u32 = 0;
    for (list1.items, list2.items) |fst, snd| {
        count += @abs(fst - snd);
    }

    return count;
}

pub fn solve2(alloc: std.mem.Allocator, input: [2]*std.ArrayList(i32)) !u32 {
    const list1 = input[0];
    const list2 = input[1];

    const last: usize = @intCast(list1.getLast());

    const diff = try alloc.alloc(u32, last);
    @memset(diff, 0);

    for (list1.items) |item1| {
        for (list2.items) |item2| {
            if (item1 == item2) {
                const diffIdx: usize = @intCast(item1);
                diff[diffIdx] += @intCast(item1);
            } 

            if (item2 > item1) {
                break;
            }
        }
    }

    var sum: u32 = 0;
    for (diff) |diffVal| {
        sum += diffVal;
    }

    return sum;
}

test "test with example input" {
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    const alloc = std.testing.allocator;

    const solution = try solve1(alloc, input);
    
    try std.testing.expectEqual(11, solution);

}
