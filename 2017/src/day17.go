package main

import (
	"aoc"
	"fmt"
)

func spinlock(step_size int, total_steps int, target_value int) int {
	pointer := 0
	state := []int{0}

	for i := 1; i < total_steps; i++ {
		pointer = ((pointer + step_size) % i) + 1
		state = append(state[:pointer], append([]int{i}, state[pointer:]...)...)
	}

	for i := range state {
		if state[i] == target_value {
			return state[i+1]
		}
	}

	panic("no matching value found")
}

func spinlock_shortcircuit(step_size int, total_steps int) int {
	pointer := 0
	output := 0

	for i := 1; i < total_steps; i++ {
		pointer = ((pointer + step_size) % i) + 1
		if pointer == 1 { // only works because 0 is always at position 0
			output = i
		}
	}

	return output
}

func main() {
	test1 := 3
	aoc.Assert_int(spinlock(test1, 2018, 2017), 638)

	input_data := 363
	fmt.Println(spinlock(input_data, 2018, 2017))
	fmt.Println(spinlock_shortcircuit(input_data, 50000000))
}
