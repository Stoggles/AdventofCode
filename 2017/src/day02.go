package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func find_checksum(input string, part2 bool) int {
	checksum := 0

	rows := strings.Split(input, "\n")
	for _, row := range rows {
		str_values := strings.Split(row, "	")
		values := make([]int, 0)
		for _, str_value := range str_values {
			value, _ := strconv.Atoi(str_value)
			values = append(values, value)
		}

		if part2 {
		Loop:
			for index1, val1 := range values {
				for index2, val2 := range values {
					if index1 == index2 {
						continue
					}
					if val1%val2 == 0 {
						checksum += (val1 / val2)
						continue Loop
					}
				}
			}
		} else {
			row_lowest := values[0]
			row_highest := values[0]
			for _, value := range values {
				if row_highest < value {
					row_highest = value
				}
				if row_lowest > value {
					row_lowest = value
				}
			}
			checksum += (row_highest - row_lowest)
		}
	}

	return checksum
}

func main() {
	test1 := "5	1	9	5\n7	5	3\n2	4	6	8"

	aoc.Assert_int(find_checksum(test1, false), 18)

	test2 := "5	9	2	8\n9	4	7	3\n3	8	6	5"

	aoc.Assert_int(find_checksum(test2, true), 9)

	input_data := aoc.Read_file("input02.txt")
	fmt.Println(find_checksum(input_data, false))
	fmt.Println(find_checksum(input_data, true))
}
