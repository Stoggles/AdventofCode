package main

import (
	"aoc"
	"fmt"
	"strings"
)

type coord struct {
	x int
	y int
}

func find_code(commands []string, grid [][]string, position coord) string {

	var code []string

	for _, line := range commands {
		for _, command := range line {
			if command == 'U' {
				if position.y == 0 {
					continue
				} else if grid[position.x][position.y-1] == "#" {
					continue
				}
				position.y -= 1
			} else if command == 'D' {
				if position.y == len(grid[position.x])-1 {
					continue
				} else if grid[position.x][position.y+1] == "#" {
					continue
				}
				position.y += 1
			} else if command == 'L' {
				if position.x == 0 {
					continue
				} else if grid[position.x-1][position.y] == "#" {
					continue
				}
				position.x -= 1
			} else if command == 'R' {
				if position.x == len(grid)-1 {
					continue
				} else if grid[position.x+1][position.y] == "#" {
					continue
				}
				position.x += 1
			}
		}
		code = append(code, grid[position.x][position.y])
	}

	return strings.Join(code, "")
}

func main() {
	test := []string{"ULL", "RRDDD", "LURDL", "UUUUD"}
	input_data := strings.Split(aoc.Read_file("2016-input02.txt"), "\n")
	grid1 := [][]string{{"1", "4", "9"}, {"2", "5", "8"}, {"3", "6", "9"}}
	grid2 := [][]string{{"#", "#", "5", "#", "#"}, {"#", "2", "6", "A", "#"}, {"1", "3", "7", "B", "D"}, {"#", "4", "8", "C", "#"}, {"#", "#", "9", "#", "#"}}

	aoc.Assert_str(find_code(test, grid1, coord{x: 1, y: 1}), "1985")
	aoc.Assert_str(find_code(test, grid2, coord{x: 0, y: 2}), "5DB3")

	fmt.Println(find_code(input_data, grid1, coord{x: 1, y: 1}))
	fmt.Println(find_code(input_data, grid2, coord{x: 0, y: 2}))
}
