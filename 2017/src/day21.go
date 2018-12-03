package main

import (
	"aoc"
	"bytes"
	"fmt"
	"math"
	"strings"
)

func rotate90(input string) string {
	array := make([][]string, 0)

	for y, line := range strings.Split(input, "/") {
		array = append(array, []string{})
		for _, character := range strings.Split(line, "") {
			array[y] = append(array[y], character)
		}
	}

	n := len(array)
	// rotate array counter-clockwise
	for i := 0; i < n/2; i++ {
		for j := i; j < n-i-1; j++ {
			tmp := array[i][j]
			array[i][j] = array[j][n-i-1]
			array[j][n-i-1] = array[n-i-1][n-j-1]
			array[n-i-1][n-j-1] = array[n-j-1][i]
			array[n-j-1][i] = tmp
		}
	}

	result_strings := make([]string, 0)
	for _, line := range array {
		result_strings = append(result_strings, strings.Join(line, ""))
	}
	result := strings.Join(result_strings, "/")

	return result
}

func transpose(input string, axis string) string {
	array := make([][]string, 0)

	for y, line := range strings.Split(input, "/") {
		array = append(array, []string{})
		for _, character := range strings.Split(line, "") {
			array[y] = append(array[y], character)
		}
	}

	result_array := make([][]string, len(array))
	for y := range result_array {
		result_array[y] = make([]string, len(array))
	}

	for y, line := range array {
		for x, character := range line {
			if axis == "x" {
				result_array[y][len(array)-x-1] = character
			} else {
				result_array[len(array)-y-1][x] = character
			}
		}
	}

	result_strings := make([]string, 0)
	for _, line := range result_array {
		result_strings = append(result_strings, strings.Join(line, ""))
	}
	result := strings.Join(result_strings, "/")

	return result
}

func build_map(input string) map[string]string {
	patterns := make(map[string]string)

	for _, line := range strings.Split(input, "\n") {
		args := strings.Split(line, " => ")

		pattern := args[0]
		transpose_pattern_x := transpose(args[0], "x")
		transpose_pattern_y := transpose(args[0], "y")
		result := args[1]

		patterns[pattern] = result

		for i := 0; i < 3; i++ { // crudely generate all possible permutations
			pattern = rotate90(pattern)
			transpose_pattern_x = rotate90(transpose_pattern_x)
			transpose_pattern_y = rotate90(transpose_pattern_y)
			patterns[pattern] = result
			patterns[transpose_pattern_x] = result
			patterns[transpose_pattern_y] = result
		}
	}

	return patterns
}

func generate_art(input string, iterations int) int {
	patterns := build_map(input)

	state := [][]string{
		{".", "#", "."},
		{".", ".", "#"},
		{"#", "#", "#"},
	}

	for i := 0; i < iterations; i++ {
		new_state := make([]string, 0)

		size := 0
		if len(state)%2 == 0 {
			size = 2
		} else if len(state)%3 == 0 {
			size = 3
		}

		for i := 0; i < len(state)/size; i++ {
			for j := 0; j < len(state)/size; j++ {
				var buffer bytes.Buffer
				for x := 0; x < size; x++ {
					for y := 0; y < size; y++ {
						buffer.WriteString(state[i*size+x][j*size+y])
					}
					if x < size-1 {
						buffer.WriteString("/")
					}
				}
				pattern, match := patterns[buffer.String()]
				if !match {
					panic("No match found")
				}
				// fmt.Println("block:", buffer.String(), "becomes", pattern)
				new_state = append(new_state, pattern)
			}
		}

		side_length := int(math.Sqrt(float64(len(new_state))))
		output_strings := make([]string, 0)
		for i := 0; i < side_length; i++ {
			string_sets := make([][]string, 0)
			j := 0
			for j = 0; j < side_length; j++ {
				string_sets = append(string_sets, strings.Split(new_state[i*side_length+j], "/"))
			}
			for a := 0; a < len(string_sets[0]); a++ {
				var buffer bytes.Buffer
				for b := 0; b < len(string_sets); b++ {
					buffer.WriteString(string_sets[b][a])
				}
				output_strings = append(output_strings, buffer.String())
			}

		}

		array := make([][]string, 0)
		for y, line := range output_strings {
			array = append(array, []string{})
			for _, character := range strings.Split(line, "") {
				array[y] = append(array[y], character)
			}
		}

		state = array
	}

	lit_pixels := 0
	for y := 0; y < len(state); y++ {
		for x := 0; x < len(state[y]); x++ {
			if state[x][y] == "#" {
				lit_pixels += 1
			}
		}
	}

	return lit_pixels
}

func main() {
	test1 := "../.# => ##./#../...\n.#./..#/### => #..#/..../..../#..#"
	aoc.Assert_int(generate_art(test1, 2), 12)

	input_data := aoc.Read_file("input21.txt")
	fmt.Println(generate_art(input_data, 5))
	fmt.Println(generate_art(input_data, 18))
}
