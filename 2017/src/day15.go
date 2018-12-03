package main

import (
	"aoc"
	"fmt"
)

func judge_pairs(a int, b int, part2 bool) int {
	factor_a := 16807
	factor_b := 48271

	pairs := 0
	loops := 0
	if part2 {
		loops = 5000000
	} else {
		loops = 40000000
	}
	for i := 0; i < loops; i++ {
		a = (a * factor_a) % 2147483647
		b = (b * factor_b) % 2147483647

		if part2 {
			for a%4 != 0 {
				a = (a * factor_a) % 2147483647
			}

			for b%8 != 0 {
				b = (b * factor_b) % 2147483647
			}
		}

		if uint16(a)-uint16(b) == 0 {
			pairs += 1
		}
	}

	return pairs
}

func main() {
	aoc.Assert_int(judge_pairs(65, 8921, false), 588)
	aoc.Assert_int(judge_pairs(65, 8921, true), 309)
	fmt.Println(judge_pairs(873, 583, false))
	fmt.Println(judge_pairs(873, 583, true))
}
