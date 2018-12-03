package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func find_capcha(input string, part2 bool) int {

	capcha := 0

	chars := strings.Split(input, "")
	step := 1

	if part2 {
		step = len(chars) / 2
	}

	for i := 0; i < len(chars); i++ {
		j := (i + step) % len(chars)

		if chars[i] == chars[j] {
			value, _ := strconv.Atoi(chars[i])
			capcha += value
		}
	}

	return capcha
}

func main() {
	test1 := "1122"
	test2 := "1111"
	test3 := "1234"
	test4 := "91212129"

	aoc.Assert_int(find_capcha(test1, false), 3)
	aoc.Assert_int(find_capcha(test2, false), 4)
	aoc.Assert_int(find_capcha(test3, false), 0)
	aoc.Assert_int(find_capcha(test4, false), 9)

	test5 := "1212"
	test6 := "1221"
	test7 := "123425"
	test8 := "123123"
	test9 := "12131415"

	aoc.Assert_int(find_capcha(test5, true), 6)
	aoc.Assert_int(find_capcha(test6, true), 0)
	aoc.Assert_int(find_capcha(test7, true), 4)
	aoc.Assert_int(find_capcha(test8, true), 12)
	aoc.Assert_int(find_capcha(test9, true), 4)

	input_data := aoc.Read_file("input01.txt")
	fmt.Println(find_capcha(input_data, false))
	fmt.Println(find_capcha(input_data, true))
}
