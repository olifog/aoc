
package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
	filename := "in.txt"
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

	slice.sort(l[:])
	slice.sort(r[:])

	diff := 0
	for i in 0..<len(l) {
		diff += abs(l[i] - r[i])
	}

	fmt.println(diff)
}

