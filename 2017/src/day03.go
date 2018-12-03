package main

import (
	"aoc"
	"fmt"
)

type coord struct {
	x int
	y int
}

func find_distance(input int) int {
	shell := 0

	for i := 0; i < input; i++ {
		if ((2*i + 1) * (2*i + 1)) >= input {
			shell = i
			break
		}
	}

	if shell == 0 {
		return 0
	}

	steps_from_corner := (((2*shell + 1) * (2*shell + 1)) - input) % (shell * 2)

	return shell + aoc.Abs(steps_from_corner-shell)
}

func find_spiral(input int) int {
	spiral := make(map[string]int)
	direction := coord{x: 1, y: 0}
	position := coord{x: 0, y: 0}
	cell_total := 0
	side_length := 1
	steps := 0

	for {
		for i := -1; i <= 1; i++ {
			for j := -1; j <= 1; j++ {
				if i == 0 && j == 0 {
					continue
				}
				cell_total += spiral[fmt.Sprintf("%d,%d", position.x+i, position.y+j)]
			}
		}

		if cell_total > input {
			break
		} else if cell_total > 0 {
			spiral[fmt.Sprintf("%d,%d", position.x, position.y)] = cell_total
		} else {
			spiral[fmt.Sprintf("%d,%d", position.x, position.y)] = 1
		}

		position = coord{x: position.x + direction.x, y: position.y + direction.y}
		steps += 1

		if steps == side_length {
			direction = coord{x: -direction.y, y: direction.x}
		} else if steps == side_length*2 {
			direction = coord{x: -direction.y, y: direction.x}
			side_length += 1
			steps = 0
		}

		cell_total = 0
	}

	return cell_total
}

func main() {
	test1 := 1
	test2 := 12
	test3 := 23
	test4 := 1024

	aoc.Assert_int(find_distance(test1), 0)
	aoc.Assert_int(find_distance(test2), 3)
	aoc.Assert_int(find_distance(test3), 2)
	aoc.Assert_int(find_distance(test4), 31)

	input_value := 265149
	fmt.Println(find_distance(input_value))
	fmt.Println(find_spiral(input_value))
}
