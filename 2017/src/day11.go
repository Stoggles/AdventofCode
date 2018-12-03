package main

import (
	"aoc"
	"fmt"
	"strings"
)

type hex_coord struct {
	x int
	y int
	z int
}

func count_steps(input string, part2 bool) int {
	instructions := strings.Split(input, ",")

	position := hex_coord{x: 0, y: 0, z: 0}
	greatest_distance := 0

	for _, instruction := range instructions {
		if instruction == "n" {
			position.x += 0
			position.y += 1
			position.z -= 1
		} else if instruction == "ne" {
			position.x += 1
			position.y += 0
			position.z -= 1
		} else if instruction == "se" {
			position.x += 1
			position.y -= 1
			position.z += 0
		} else if instruction == "s" {
			position.x += 0
			position.y -= 1
			position.z += 1
		} else if instruction == "sw" {
			position.x -= 1
			position.y += 0
			position.z += 1
		} else if instruction == "nw" {
			position.x -= 1
			position.y += 1
			position.z += 0
		}

		current_distance := (aoc.Abs(position.x) + aoc.Abs(position.y) + aoc.Abs(position.z)) / 2
		if current_distance > greatest_distance {
			greatest_distance = current_distance
		}
	}

	if part2 {
		return greatest_distance
	} else {
		return (aoc.Abs(position.x) + aoc.Abs(position.y) + aoc.Abs(position.z)) / 2
	}
}

func main() {
	test1 := "ne,ne,ne"
	test2 := "ne,ne,sw,sw"
	test3 := "ne,ne,s,s"
	test4 := "se,sw,se,sw,sw"

	aoc.Assert_int(count_steps(test1, false), 3)
	aoc.Assert_int(count_steps(test2, false), 0)
	aoc.Assert_int(count_steps(test3, false), 2)
	aoc.Assert_int(count_steps(test4, false), 3)

	input_data := aoc.Read_file("input11.txt")
	fmt.Println(count_steps(input_data, false))
	fmt.Println(count_steps(input_data, true))
}
