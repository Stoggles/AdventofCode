package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func execute(input string) int {
	lines := strings.Split(input, "\n")
	instructions := make([][]string, 0)
	for _, instruction := range lines {
		instructions = append(instructions, strings.Split(instruction, " "))
	}

	registers := make(map[string]int)
	instruction_pointer := 0
	mul_count := 0

	for instruction_pointer < len(instructions) {
		instruction := instructions[instruction_pointer]
		switch ins := instruction[0]; ins {
		case "set":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] = arg
		case "sub":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] -= arg
		case "mul":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] *= arg
			mul_count += 1
		case "jnz":
			arg, err := strconv.Atoi(instruction[1])
			if err != nil {
				arg = registers[instruction[1]]
			}
			if arg != 0 {
				jump, err := strconv.Atoi(instruction[2])
				if err != nil {
					jump = registers[instruction[2]]
				}
				instruction_pointer += jump
				continue
			}
		}
		instruction_pointer += 1
	}

	return mul_count
}

func part2() int {
	b := 100*65 + 100000
	c := b + 17000
	d := 0
	f := 1
	h := 0

	// counts prime numbers
	for b <= c {
		f = 1
		d = 2
		for d != b {
			if b%d == 0 {
				f = 0
				break
			}
			d += 1
		}
		if f == 0 {
			h += 1
		}
		b += 17
	}

	return h
}

func main() {
	input_data := aoc.Read_file("input23.txt")
	fmt.Println(execute(input_data))
	fmt.Println(part2())
}
