package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
	"time"
)

func execute(input string) int {
	lines := strings.Split(input, "\n")
	instructions := make([][]string, 0)
	for _, instruction := range lines {
		instructions = append(instructions, strings.Split(instruction, " "))
	}

	registers := make(map[string]int)
	output := make([]int, 0)
	instruction_pointer := 0

	for instruction_pointer < len(instructions) {
		instruction := instructions[instruction_pointer]
		switch ins := instruction[0]; ins {
		case "snd":
			arg, err := strconv.Atoi(instruction[1])
			if err != nil {
				arg = registers[instruction[1]]
			}
			output = append(output, arg)
		case "set":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] = arg
		case "add":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] += arg
		case "mul":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] *= arg
		case "mod":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] %= arg
		case "rcv":
			arg, err := strconv.Atoi(instruction[1])
			if err != nil {
				arg = registers[instruction[1]]
			}
			if arg != 0 {
				return output[len(output)-1]
			}
		case "jgz":
			arg, err := strconv.Atoi(instruction[1])
			if err != nil {
				arg = registers[instruction[1]]
			}
			if arg > 0 {
				jump, err := strconv.Atoi(instruction[2])
				if err != nil {
					jump = registers[instruction[2]]
				}
				instruction_pointer += jump
				continue
			}
		}
		instruction_pointer += 1
	}

	panic("No value recovered")
}

func execute_parallel(input string, thread_number int, in_chan chan int, out_chan chan int, result chan int) {
	lines := strings.Split(input, "\n")
	instructions := make([][]string, 0)
	for _, instruction := range lines {
		instructions = append(instructions, strings.Split(instruction, " "))
	}

	registers := map[string]int{"p": thread_number}
	instruction_pointer := 0
	sent_counter := 0

	for instruction_pointer < len(instructions) {
		instruction := instructions[instruction_pointer]
		switch ins := instruction[0]; ins {
		case "snd":
			arg, err := strconv.Atoi(instruction[1])
			if err != nil {
				arg = registers[instruction[1]]
			}
			out_chan <- arg
			sent_counter += 1
		case "set":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] = arg
		case "add":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] += arg
		case "mul":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] *= arg
		case "mod":
			arg, err := strconv.Atoi(instruction[2])
			if err != nil {
				arg = registers[instruction[2]]
			}
			registers[instruction[1]] %= arg
		case "rcv":
			select {
			case recv := <-in_chan:
				registers[instruction[1]] = recv
			case <-time.After(time.Millisecond * 1):
				result <- sent_counter
				return
			}
		case "jgz":
			arg, err := strconv.Atoi(instruction[1])
			if err != nil {
				arg = registers[instruction[1]]
			}
			if arg > 0 {
				jump, err := strconv.Atoi(instruction[2])
				if err != nil {
					jump = registers[instruction[2]]
				}
				instruction_pointer += jump
				continue
			}
		}
		instruction_pointer += 1
	}

	panic("No deadlock encountered")
}

func main() {
	test1 := "set a 1\nadd a 2\nmul a a\nmod a 5\nsnd a\nset a 0\nrcv a\njgz a -1\nset a 1\njgz a -2"
	aoc.Assert_int(execute(test1), 4)

	test2 := "snd 1\nsnd 2\nsnd p\nrcv a\nrcv b\nrcv c\nrcv d"
	test_chan_1 := make(chan int, 10)
	test_chan_2 := make(chan int, 10)
	test_result_0 := make(chan int)
	test_result_1 := make(chan int)
	go execute_parallel(test2, 0, test_chan_1, test_chan_2, test_result_0)
	go execute_parallel(test2, 1, test_chan_2, test_chan_1, test_result_1)

	aoc.Assert_int(<-test_result_1, 3)

	input_data := aoc.Read_file("input18.txt")
	fmt.Println(execute(input_data))

	chan_1 := make(chan int, 1000)
	chan_2 := make(chan int, 1000)
	result_0 := make(chan int)
	result_1 := make(chan int)
	go execute_parallel(input_data, 0, chan_1, chan_2, result_0)
	go execute_parallel(input_data, 1, chan_2, chan_1, result_1)

	fmt.Println(<-result_1)
}
