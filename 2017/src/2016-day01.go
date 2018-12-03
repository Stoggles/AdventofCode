package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

type coord struct {
	x int
	y int
}

func find_distance(input string, part2 bool) int {
	steps := strings.Split(input, ", ")
	direction := coord{x: 0, y: -1}
	position := coord{x: 0, y: 0}

	var previous_locations []coord

Loop:
	for _, step := range steps {
		dir := step[:1]
		dist, _ := strconv.Atoi(step[1:])

		if dir == "L" {
			x := direction.x
			direction.x = -direction.y
			direction.y = x
		} else if dir == "R" {
			x := direction.x
			direction.x = direction.y
			direction.y = -x
		}

		if part2 {
			for i := 1; i <= dist; i++ {
				position.x += direction.x
				position.y += direction.y

				for _, location := range previous_locations {
					if location.x == position.x && location.y == position.y {
						break Loop
					}
				}
				previous_locations = append(previous_locations, position)
			}
		} else {
			position.x += (direction.x * dist)
			position.y += (direction.y * dist)
		}
	}

	if position.x < 0 {
		position.x *= -1
	}

	if position.y < 0 {
		position.y *= -1
	}

	return position.x + position.y
}

func main() {
	test1 := "R2, L3"
	test2 := "R2, R2, R2"
	test3 := "R5, L5, R5, R3"
	test4 := "R8, R4, R4, R8"

	aoc.Assert_int(find_distance(test1, false), 5)
	aoc.Assert_int(find_distance(test2, false), 2)
	aoc.Assert_int(find_distance(test3, false), 12)
	aoc.Assert_int(find_distance(test4, true), 4)

	input_data := aoc.Read_file("2016-input01.txt")
	fmt.Println(find_distance(input_data, false))
	fmt.Println(find_distance(input_data, true))
}
