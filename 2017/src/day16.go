package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func build_inital_state(dancers int) []string {
	state := make([]string, dancers)

	for k := range state {
		state[k] = string(rune(k + 97))
	}

	return state
}

func dance(moves []string, state []string) []string {
	for _, move := range moves {
		if move[:1] == "s" {
			spin_size, _ := strconv.Atoi(move[1:])
			state = append(state[len(state)-spin_size:], state[:len(state)-spin_size]...)
		} else if move[:1] == "x" {
			args := strings.Split(move[1:], "/")
			a, _ := strconv.Atoi(args[0])
			b, _ := strconv.Atoi(args[1])
			state[a], state[b] = state[b], state[a]
		} else if move[:1] == "p" {
			args := strings.Split(move[1:], "/")
			a := 0
			b := 0
			for index, value := range state {
				if value == args[0] {
					a = index
				}
				if value == args[1] {
					b = index
				}
			}
			state[a], state[b] = state[b], state[a]
		}
	}

	return state
}

func multi_dance(input string, dancers int, iterations int) string {
	moves := strings.Split(input, ",")
	state := build_inital_state(dancers)
	previous_states := []string{}
	dances := 0

	for i := 0; i < iterations; i++ {
		state = dance(moves, state)
		dances += 1

		for k, v := range previous_states {
			if v == strings.Join(state, "") {
				loop_length := i - k
				for i+loop_length < iterations {
					i += loop_length
				}
				break
			}
		}

		previous_states = append(previous_states, strings.Join(state, ""))

	}

	fmt.Println(dances)

	return strings.Join(state, "")
}

func main() {
	test1 := "s1,x3/4,pe/b"
	aoc.Assert_str(multi_dance(test1, 5, 1), "baedc")
	aoc.Assert_str(multi_dance(test1, 5, 2), "ceadb")

	input_data := aoc.Read_file("input16.txt")
	fmt.Println(multi_dance(input_data, 16, 1))
	fmt.Println(multi_dance(input_data, 16, 1000000000))

}
