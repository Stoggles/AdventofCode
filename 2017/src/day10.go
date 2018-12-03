package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func knot_hash(input string, array_max int, part2 bool) {
	operations := make([]int, 0)
	if part2 {
		for _, rune := range []rune(input) {
			operations = append(operations, int(rune))
		}
		operations = append(operations, 17, 31, 73, 47, 23)
	} else {
		for _, instruction := range strings.Split(input, ",") {
			value, _ := strconv.Atoi(instruction)
			operations = append(operations, value)
		}
	}

	list := make([]int, array_max)
	for index, _ := range list {
		list[index] = index
	}

	position_pointer := 0
	skip_size := 0
	loops := 1

	if part2 {
		loops = 64
	}

	for i := 0; i < loops; i++ {
		for _, operation := range operations {
			for i, j := position_pointer, position_pointer+operation-1; i < j; i, j = i+1, j-1 {
				list[i%array_max], list[j%array_max] = list[j%array_max], list[i%array_max]
			}

			position_pointer += (operation + skip_size)
			skip_size += 1
		}
	}

	if part2 {
		output_array := make([]string, 16)
		for i := 0; i < (len(list) / 16); i++ {
			output := list[i*16]
			for j := 1; j < 16; j++ {
				if (i*16 + j) >= len(list) {
					break
				}
				output ^= list[i*16+j]
			}
			output_array = append(output_array, fmt.Sprintf("%02x", output))
		}
		fmt.Println(strings.Join(output_array, ""))
	} else {
		fmt.Println(list[0] * list[1])
	}
}

func main() {
	input_data := aoc.Read_file("input10.txt")
	knot_hash(input_data, 256, false)
	knot_hash(input_data, 256, true)
}
