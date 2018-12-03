package main

import (
	"aoc"
	"fmt"
	"strings"
)

func count_score(input string, part2 bool) int {
	chars := strings.Split(input, "")

	depth := 0
	score := 0
	garbage_mode := false
	garbage_count := 0

	for i := 0; i < len(chars); i++ {
		if chars[i] == "!" {
			i += 1
			continue
		}
		if garbage_mode {
			if chars[i] == ">" {
				garbage_mode = false
			} else {
				garbage_count += 1
			}
		} else {
			if chars[i] == "{" {
				depth += 1
			} else if chars[i] == "}" {
				score += depth
				depth -= 1
			} else if chars[i] == "<" {
				garbage_mode = true
			}
		}
	}

	if part2 {
		return garbage_count
	} else {
		return score
	}
}

func main() {
	test1 := "{}"
	test2 := "{{{}}}"
	test3 := "{{},{}}"
	test4 := "{{{},{},{{}}}}"
	test5 := "{<a>,<a>,<a>,<a>}"
	test6 := "{{<ab>},{<ab>},{<ab>},{<ab>}}"
	test7 := "{{<!!>},{<!!>},{<!!>},{<!!>}}"
	test8 := "{{<a!>},{<a!>},{<a!>},{<ab>}}"

	aoc.Assert_int(count_score(test1, false), 1)
	aoc.Assert_int(count_score(test2, false), 6)
	aoc.Assert_int(count_score(test3, false), 5)
	aoc.Assert_int(count_score(test4, false), 16)
	aoc.Assert_int(count_score(test5, false), 1)
	aoc.Assert_int(count_score(test6, false), 9)
	aoc.Assert_int(count_score(test7, false), 9)
	aoc.Assert_int(count_score(test8, false), 3)

	test9 := "<>"
	test10 := "<random characters>"
	test11 := "<<<<>"
	test12 := "<{!>}>"
	test13 := "<!!>"
	test14 := "<!!!>>"
	test15 := "<{o\"i!a,<{i<a>"

	aoc.Assert_int(count_score(test9, true), 0)
	aoc.Assert_int(count_score(test10, true), 17)
	aoc.Assert_int(count_score(test11, true), 3)
	aoc.Assert_int(count_score(test12, true), 2)
	aoc.Assert_int(count_score(test13, true), 0)
	aoc.Assert_int(count_score(test14, true), 0)
	aoc.Assert_int(count_score(test15, true), 10)

	input_data := aoc.Read_file("input09.txt")
	fmt.Println(count_score(input_data, false))
	fmt.Println(count_score(input_data, true))
}
