package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func stringify(array []int) string {
	string_values := make([]string, len(array))
	for _, val := range array {
		string_values = append(string_values, strconv.Itoa(val))
	}

	return strings.Join(string_values, "")
}

func count_cycles(input string, part2 bool) int {
	memory_cells := make([]int, 0)
	for _, line := range strings.Split(input, "\t") {
		value, _ := strconv.Atoi(line)
		memory_cells = append(memory_cells, value)
	}

	history := make([]string, 0)
	history = append(history, stringify(memory_cells))

	for {
		cell_pointer := 0
		redistribution_amount := memory_cells[0]

		for index, cell := range memory_cells {
			if cell > redistribution_amount {
				redistribution_amount = cell
				cell_pointer = index
			}
		}

		memory_cells[cell_pointer] = 0
		for i := 0; i < redistribution_amount; i++ {
			cell_pointer += 1
			memory_cells[cell_pointer%len(memory_cells)] += 1
		}

		string_val := stringify(memory_cells)

		for index, hist_val := range history {
			if hist_val == string_val {
				if part2 {
					return len(history) - index
				}
				return len(history)
			}
		}

		history = append(history, string_val)
	}
}

func main() {
	test1 := "0\t2\t7\t0"

	aoc.Assert_int(count_cycles(test1, false), 5)
	aoc.Assert_int(count_cycles(test1, true), 4)

	input_data := aoc.Read_file("input06.txt")
	fmt.Println(count_cycles(input_data, false))
	fmt.Println(count_cycles(input_data, true))
}
