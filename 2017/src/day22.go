package main

import (
	"aoc"
	"fmt"
	"math"
	"strings"
)

type coord struct {
	x int
	y int
}

func parse_input(input string) map[coord]string {
	grid := make(map[coord]string)

	for y, line := range strings.Split(input, "\n") {
		for x, character := range strings.Split(line, "") {
			grid[coord{x: x, y: y}] = character
		}
	}

	return grid
}

func infect_the_grid(input string, steps int, part2 bool) int {
	grid := parse_input(input)

	centre := int(math.Sqrt(float64(len(grid))) / 2)
	position := coord{x: centre, y: centre}
	direction := coord{x: 0, y: -1}
	infected := 0

	for i := 0; i < steps; i++ {
		if part2 {
			if grid[position] == "W" {
				grid[position] = "#"
				infected += 1
			} else if grid[position] == "#" {
				x := direction.x
				direction.x = -direction.y
				direction.y = x
				grid[position] = "F"
			} else if grid[position] == "F" {
				direction = coord{x: -direction.x, y: -direction.y}
				grid[position] = "."
			} else {
				x := direction.x
				direction.x = direction.y
				direction.y = -x
				grid[position] = "W"
			}
		} else {
			if grid[position] == "#" {
				x := direction.x
				direction.x = -direction.y
				direction.y = x
				grid[position] = "."
			} else {
				x := direction.x
				direction.x = direction.y
				direction.y = -x
				grid[position] = "#"
				infected += 1
			}
		}

		position = coord{x: position.x + direction.x, y: position.y + direction.y}
	}

	return infected
}

func main() {
	test1 := "..#\n#..\n..."
	aoc.Assert_int(infect_the_grid(test1, 10000, false), 5587)
	aoc.Assert_int(infect_the_grid(test1, 10000000, true), 2511944)

	input_data := aoc.Read_file("input22.txt")
	fmt.Println(infect_the_grid(input_data, 10000, false))
	fmt.Println(infect_the_grid(input_data, 10000000, true))
}
