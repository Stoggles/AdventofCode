package main

import (
	"aoc"
	"fmt"
	"regexp"
	"strings"
)

type coord struct {
	x int
	y int
}

func find_path(input string, part2 bool) string {
	grid := map[coord]string{}
	stations := []string{}

	for y, row := range strings.Split(input, "\n") {
		for x, char := range row {
			if char != ' ' {
				grid[coord{x: x, y: y}] = string(char)
			}
		}
	}

	position := coord{x: 0, y: 0}
	direction := coord{x: 0, y: 1}
	steps := 0

	station := regexp.MustCompile("[A-Z]")
	valid_move := regexp.MustCompile("[A-Z-|+]")

	// get the starting positon
	for k, v := range grid {
		if k.y == 0 && v == "|" {
			position = k
			break
		}
	}

	for {
		position.x += direction.x
		position.y += direction.y
		steps += 1

		cell := grid[position]

		if station.MatchString(cell) {
			stations = append(stations, cell)
			continue
		} else if cell == "|" || cell == "-" {
			continue
		} else if cell == "+" {
			if direction.x != 0 {
				if valid_move.MatchString(grid[coord{x: position.x + direction.x, y: position.y}]) {
					continue
				} else {
					if valid_move.MatchString(grid[coord{x: position.x, y: position.y + 1}]) {
						direction = coord{x: 0, y: 1}
					} else if valid_move.MatchString(grid[coord{x: position.x, y: position.y - 1}]) {
						direction = coord{x: 0, y: -1}
					} else {
						panic("No valid move")
					}
				}
			} else if direction.y != 0 {
				if valid_move.MatchString(grid[coord{x: position.x, y: position.y + direction.y}]) {
					continue
				} else {
					if valid_move.MatchString(grid[coord{x: position.x + 1, y: position.y}]) {
						direction = coord{x: 1, y: 0}
					} else if valid_move.MatchString(grid[coord{x: position.x - 1, y: position.y}]) {
						direction = coord{x: -1, y: 0}
					} else {
						panic("No valid move")
					}
				}
			}
		} else {
			break
		}
	}

	if part2 {
		return fmt.Sprintf("%d", steps)
	} else {
		return strings.Join(stations, "")
	}
}

func main() {
	test1 := "     |          \n     |  +--+    \n     A  |  C    \n F---|----E|--+ \n     |  |  |  D \n     +B-+  +--+ "
	aoc.Assert_str(find_path(test1, false), "ABCDEF")
	aoc.Assert_str(find_path(test1, true), "38")

	input_data := aoc.Read_file_no_trim("input19.txt")
	fmt.Println(find_path(input_data, false))
	fmt.Println(find_path(input_data, true))
}
