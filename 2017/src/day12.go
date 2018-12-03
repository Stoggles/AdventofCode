package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

func count(input string, part2 bool) int {
	lines := strings.Split(input, "\n")

	nodes := make([][]int, 0)

	for _, line := range lines {
		values := strings.Split(line, " ")
		int_instructions := []int{}

		value, _ := strconv.Atoi(values[0])
		int_instructions = append(int_instructions, value)

		for i := 2; i < len(values); i++ {
			value, _ := strconv.Atoi(strings.Trim(values[i], ","))
			int_instructions = append(int_instructions, value)
		}

		nodes = append(nodes, int_instructions)
	}

	group := []int{}
	add_children(0, &group, &nodes)

	if part2 {
		groups := 1
		for _, value := range nodes {
			if value == nil {
				continue
			}

			group := []int{}
			add_children(value[0], &group, &nodes)
			groups += 1
		}
		return groups
	} else {
		return len(group)
	}

}

func add_children(root int, group *[]int, nodes *[][]int) {
	*group = append(*group, root)
Loop:
	for i := 1; i < len((*nodes)[root]); i++ {
		for j := 0; j < len(*group); j++ {
			if (*nodes)[root][i] == (*group)[j] {
				continue Loop
			}
		}
		add_children((*nodes)[root][i], group, nodes)
	}

	(*nodes)[root] = nil
}

func main() {
	test1 := "0 <-> 2\n1 <-> 1\n2 <-> 0, 3, 4\n3 <-> 2, 4\n4 <-> 2, 3, 6\n5 <-> 6\n6 <-> 4, 5"

	aoc.Assert_int(count(test1, false), 6)
	aoc.Assert_int(count(test1, true), 2)

	input_data := aoc.Read_file("input12.txt")
	fmt.Println(count(input_data, false))
	fmt.Println(count(input_data, true))
}
