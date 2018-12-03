package main

import (
	"fmt"
	"strings"
)

func knot_hash(input string) string {
	operations := make([]int, 0)
	for _, rune := range []rune(input) {
		operations = append(operations, int(rune))
	}
	operations = append(operations, 17, 31, 73, 47, 23)

	list := make([]int, 256)
	for index := range list {
		list[index] = index
	}

	position_pointer := 0
	skip_size := 0
	loops := 64

	for i := 0; i < loops; i++ {
		for _, operation := range operations {
			for i, j := position_pointer, position_pointer+operation-1; i < j; i, j = i+1, j-1 {
				list[i%256], list[j%256] = list[j%256], list[i%256]
			}

			position_pointer += (operation + skip_size)
			skip_size += 1
		}
	}

	output_array := make([]string, 16)
	for i := 0; i < (len(list) / 16); i++ {
		output := list[i*16]
		for j := 1; j < 16; j++ {
			if (i*16 + j) >= len(list) {
				break
			}
			output ^= list[i*16+j]
		}
		output_array = append(output_array, fmt.Sprintf("%08b", output))
	}

	return strings.Join(output_array, "")
}

func count_used_squares(input string) int {
	used_squares := 0

	for i := 0; i < 128; i++ {
		hash := knot_hash(fmt.Sprintf("%s-%d", input, i))
		used_squares += strings.Count(hash, "1")
	}

	return used_squares
}

func count_regions(input string) int {
	grid := make([][]string, 128)

	for i := 0; i < 128; i++ {
		hash := knot_hash(fmt.Sprintf("%s-%d", input, i))
		grid[i] = strings.Split(hash, "")
	}

	regions := 0
	visited := [128][128]bool{}

	for y := 0; y < 128; y++ {
		for x := 0; x < 128; x++ {
			if visited[x][y] || grid[x][y] == "0" {
				continue
			}

			visit(x, y, grid, &visited)
			regions += 1
		}

	}

	return regions
}

func visit(x int, y int, grid [][]string, visited *[128][128]bool) {
	if visited[x][y] {
		return
	} else {
		(*visited)[x][y] = true
	}

	if grid[x][y] == "0" {
		return
	}

	if x > 0 {
		visit(x-1, y, grid, visited)
	}
	if x < 127 {
		visit(x+1, y, grid, visited)
	}
	if y > 0 {
		visit(x, y-1, grid, visited)
	}
	if y < 127 {
		visit(x, y+1, grid, visited)
	}
}

func main() {
	input_data := "jzgqcdpd"
	fmt.Println(count_used_squares(input_data))
	fmt.Println(count_regions(input_data))
}
