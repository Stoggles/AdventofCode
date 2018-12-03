package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func build_firewalls(input string) (map[int]int, int) {
	firewalls := make(map[int]int)

	size := 0
	for _, line := range strings.Split(input, "\n") {
		values := strings.Split(line, ": ")
		layer, _ := strconv.Atoi(values[0])
		depth, _ := strconv.Atoi(values[1])
		firewalls[layer] = depth
		if layer > size {
			size = layer
		}
	}

	return firewalls, size
}

func count_severity(firewalls map[int]int, size int, starting_time int) int {
	severity := 0
	for i, j := starting_time, 0; i <= starting_time+size; i, j = i+1, j+1 {
		if firewalls[j] == 0 {
			continue
		} else if i%(2*firewalls[j]-2) == 0 {
			severity += j * firewalls[j]
		}
	}

	return severity
}

func caught_at_time(firewalls map[int]int, size int, starting_time int) bool {
	for i, j := starting_time, 0; i <= starting_time+size; i, j = i+1, j+1 {
		if firewalls[j] == 0 {
			continue
		} else if i%(2*firewalls[j]-2) == 0 {
			return true
		}
	}

	return false
}

func get_delay(firewalls map[int]int, size int) int {
	time := 0
	for caught_at_time(firewalls, size, time) {
		time += 1
	}

	return time
}

func main() {
	test1 := "0: 3\n1: 2\n4: 4\n6: 4"
	test_firewalls, test_size := build_firewalls(test1)
	aoc.Assert_int(count_severity(test_firewalls, test_size, 0), 24)
	aoc.Assert_int(get_delay(test_firewalls, test_size), 10)

	input_data := aoc.Read_file("input13.txt")
	input_firewalls, input_size := build_firewalls(input_data)
	fmt.Println(count_severity(input_firewalls, input_size, 0))
	fmt.Println(get_delay(input_firewalls, input_size))
}
