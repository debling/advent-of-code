const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, world!\n", .{});
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

    var list1 = std.ArrayList(i32).init(alloc);
    defer list1.deinit();

    var list2 = std.ArrayList(i32).init(alloc);
    defer list2.deinit();

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

    var count: u32 = 0;
    for (list1.items, list2.items) |fst, snd| {
        std.log.warn("fst {} snd {}", .{fst, snd});
        count += @abs(fst - snd);
    }

    try std.testing.expectEqual(11, count);

}
