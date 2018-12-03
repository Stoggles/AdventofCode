package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

type node struct {
	a    int
	b    int
	used bool
}

func parse_input(input_data string) []node {
	nodes := make([]node, 0)

	for _, line := range strings.Split(input_data, "\n") {
		args := strings.Split(line, "/")
		a, _ := strconv.Atoi(args[0])
		b, _ := strconv.Atoi(args[1])
		nodes = append(nodes, node{a: a, b: b})
	}

	return nodes
}

var maxLength int
var maxScore int

func build_bridge(nodes []node, part2 bool) int {
	maxScore, maxLength = -1, -1
	recursive_bridge_build(nodes, 0, 0, 0, part2)
	return maxScore
}

func recursive_bridge_build(nodes []node, target int, score int, length int, part2 bool) {
	if part2 {
		if maxLength <= length {
			maxScore = score
			maxLength = length
		}
	} else {
		if maxScore < score {
			maxScore = score
			maxLength = length
		}
	}

	for i, node := range nodes {
		if node.used {
			continue
		}
		if node.a == target {
			nodes[i].used = true
			recursive_bridge_build(nodes, node.b, score+node.a+node.b, length+1, part2)
			nodes[i].used = false
		}
		if node.b == target {
			nodes[i].used = true
			recursive_bridge_build(nodes, node.a, score+node.a+node.b, length+1, part2)
			nodes[i].used = false
		}
	}
}

func main() {
	test1 := "0/2\n2/2\n2/3\n3/4\n3/5\n0/1\n10/1\n9/10"
	aoc.Assert_int(build_bridge(parse_input(test1), false), 31)
	aoc.Assert_int(build_bridge(parse_input(test1), true), 19)

	input_data := aoc.Read_file("input24.txt")
	fmt.Println(build_bridge(parse_input(input_data), false))
	fmt.Println(build_bridge(parse_input(input_data), true))
}
