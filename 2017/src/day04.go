package main

import (
	"aoc"
	"fmt"
	"sort"
	"strings"
)

func count_valid_passwords(input string, part2 bool) int {
	valid_passwords := 0

Loop:
	for _, row := range strings.Split(input, "\n") {
		words := strings.Split(row, " ")

		if part2 {
			var sorted_words []string
			for _, word := range words {
				chars := strings.Split(word, "")
				sort.Strings(chars)
				sorted_words = append(sorted_words, strings.Join(chars, ""))
			}

			words = sorted_words
		}

		// order irrelevant pair generation
		for i := 0; i < len(words)-1; i++ {
			for j := i + 1; j < len(words); j++ {
				if words[i] == words[j] {
					continue Loop
				}
			}
		}
		valid_passwords += 1
	}

	return valid_passwords
}

func main() {
	test1 := "aa bb cc dd ee\naa bb cc dd aa\naa bb cc dd aaa "

	aoc.Assert_int(count_valid_passwords(test1, false), 2)

	test2 := "abcde fghij\nabcde xyz ecdab\na ab abc abd abf abj\niiii oiii ooii oooi oooo\noiii ioii iioi iiio"

	aoc.Assert_int(count_valid_passwords(test2, true), 3)

	input_data := aoc.Read_file("input04.txt")
	fmt.Println(count_valid_passwords(input_data, false))
	fmt.Println(count_valid_passwords(input_data, true))
}
