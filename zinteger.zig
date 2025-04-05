const std = @import("std");

fn double(num: *std.ArrayList(u8)) !void {
    var carry: u8 = 0;
    for (num.items, 0..) |digit, i| {
        const product: u8 = (digit - '0') * 2 + carry;
        num.items[i] = (product % 10) + '0';
        carry = if (product > 9) 1 else 0;
    }
    if (carry > 0) try num.append(carry + '0');
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const bits = 65535; // number of bits in a u65535
    var i: usize = 1;
    var big_num = std.ArrayList(u8).init(allocator);
    try big_num.append('2');
    while (i < bits) : (i += 1) {
        try double(&big_num);
    }

    big_num.items[0] -= 1; // last digit of a power of 2 must be either 2,4,8,or 6. it can never be 0, so it will never underflow
    std.mem.reverse(u8, big_num.items);
    std.debug.print("The max unsigned value in zig is: {s}\n", .{big_num.items});
}
