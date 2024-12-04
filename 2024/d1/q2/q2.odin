
package main

import "core:os"
import "core:strings"
import "core:fmt"
import "core:strconv"

main :: proc() {
    filename := "in.q2.txt"
    data, ok := os.read_entire_file(filename, context.allocator)
    if !ok {
        return
    }
    defer delete(data, context.allocator)

    l: [dynamic]int
    r: [dynamic]int

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        parts := strings.split(line, "   ") // this should only ever be 2 parts
        if len(parts) != 2 {
            fmt.println("error: invalid line")
            return
        }

        l_part := strings.trim_space(parts[0])
        r_part := strings.trim_space(parts[1])

        l_num, l_ok := strconv.parse_int(l_part)
        r_num, r_ok := strconv.parse_int(r_part)
        if !l_ok || !r_ok {
            fmt.println("error: invalid number")
            return
        }

        append(&l, l_num)
        append(&r, r_num)
    }

    // create a hashmap of value to count for all of r
    r_counts: map[int]int
    for r_val in r {
        r_counts[r_val] += 1
    }

    score := 0
    for l_val in l {
        if count, ok := r_counts[l_val]; ok {
            score += count * l_val
        }
    }

    fmt.println(score)
}

