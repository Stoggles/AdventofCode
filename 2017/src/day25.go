package main

import (
	"aoc"
	"fmt"
)

type state struct {
	set_val int
	set_state string
	move_direction string
}

func turing(instuctions map[string]state, steps int) int {
	state := "a"
	tape := make(map[int]int)
	pointer := 0

	for i := 0; i < steps; i++ {
		instuction := instuctions[fmt.Sprintf("%s%d", state, tape[pointer])]

		tape[pointer] = instuction.set_val
		state = instuction.set_state
		if instuction.move_direction == "l" {
			pointer -= 1
		} else if instuction.move_direction == "r" {
			pointer += 1
		}
	}

	checksum := 0
	for _,v := range tape {
		checksum += v
	}

	return checksum
}

func main() {
	test1 := map[string]state{
		"a0": state{set_val: 1, move_direction: "r", set_state: "b"},
		"a1": state{set_val: 0, move_direction: "l", set_state: "b"},
		"b0": state{set_val: 1, move_direction: "l", set_state: "a"},
		"b1": state{set_val: 1, move_direction: "r", set_state: "a"},
	}
	aoc.Assert_int(turing(test1, 6), 3)

	input_data := map[string]state{
		"a0": state{set_val: 1, move_direction: "r", set_state: "b"},
		"a1": state{set_val: 0, move_direction: "l", set_state: "d"},
		"b0": state{set_val: 1, move_direction: "r", set_state: "c"},
		"b1": state{set_val: 0, move_direction: "r", set_state: "f"},
		"c0": state{set_val: 1, move_direction: "l", set_state: "c"},
		"c1": state{set_val: 1, move_direction: "l", set_state: "a"},
		"d0": state{set_val: 0, move_direction: "l", set_state: "e"},
		"d1": state{set_val: 1, move_direction: "r", set_state: "a"},
		"e0": state{set_val: 1, move_direction: "l", set_state: "a"},
		"e1": state{set_val: 0, move_direction: "r", set_state: "b"},
		"f0": state{set_val: 0, move_direction: "r", set_state: "c"},
		"f1": state{set_val: 0, move_direction: "r", set_state: "e"},
	}

	fmt.Println(turing(input_data, 12302209))
}
