package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

type instruction struct {
	target_register      string
	sign                 int
	operand              int
	conditional_register string
	condition            string
	conditional_value    int
}

func get_largest_register(input string, part2 bool) int {
	registers := make(map[string]int)
	max_ever := 0
	max_final := 0

	for _, line := range strings.Split(input, "\n") {
		operands := strings.Split(line, " ")
		instruction := instruction{target_register: operands[0], conditional_register: operands[4], condition: operands[5]}
		instruction.operand, _ = strconv.Atoi(operands[2])
		instruction.conditional_value, _ = strconv.Atoi(operands[6])
		if operands[1] == "inc" {
			instruction.sign = 1
		} else {
			instruction.sign = -1
		}

		if instruction.condition == "==" && registers[instruction.conditional_register] == instruction.conditional_value ||
			instruction.condition == "!=" && registers[instruction.conditional_register] != instruction.conditional_value ||
			instruction.condition == ">" && registers[instruction.conditional_register] > instruction.conditional_value ||
			instruction.condition == "<" && registers[instruction.conditional_register] < instruction.conditional_value ||
			instruction.condition == ">=" && registers[instruction.conditional_register] >= instruction.conditional_value ||
			instruction.condition == "<=" && registers[instruction.conditional_register] <= instruction.conditional_value {
			registers[instruction.target_register] += instruction.sign * instruction.operand
			if registers[instruction.target_register] > max_ever {
				max_ever = registers[instruction.target_register]
			}
		}
	}

	for _, v := range registers {
		if v > max_final {
			max_final = v
		}
	}

	if part2 {
		return max_ever
	} else {
		return max_final
	}
}

func main() {
	test1 := "b inc 5 if a > 1\na inc 1 if b < 5\nc dec -10 if a >= 1\nc inc -20 if c == 10"

	aoc.Assert_int(get_largest_register(test1, false), 1)
	aoc.Assert_int(get_largest_register(test1, true), 10)

	input_data := aoc.Read_file("input08.txt")
	fmt.Println(get_largest_register(input_data, false))
	fmt.Println(get_largest_register(input_data, true))
}
