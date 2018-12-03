package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func count_jumps(input string, part2 bool) int {
	instructions := make([]int, 0)
	for _, line := range strings.Split(input, "\n") {
		value, _ := strconv.Atoi(line)
		instructions = append(instructions, value)
	}

	jumps := 0
	program_counter := 0

	for {
		if program_counter >= len(instructions) || program_counter < 0 {
			break
		}

		offset := instructions[program_counter]
		if part2 && offset >= 3 {
			instructions[program_counter] -= 1
		} else {
			instructions[program_counter] += 1
		}

		program_counter += offset
		jumps += 1
	}

	return jumps
}

func main() {
	test1 := "0\n3\n0\n1\n-3"

	aoc.Assert_int(count_jumps(test1, false), 5)
	aoc.Assert_int(count_jumps(test1, true), 10)

	input_data := aoc.Read_file("input05.txt")
	fmt.Println(count_jumps(input_data, false))
	fmt.Println(count_jumps(input_data, true))
}
