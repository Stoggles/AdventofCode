package main

import (
	"aoc"
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

type coord struct {
	x int
	y int
	z int
}

type particle struct {
	p         coord
	v         coord
	a         coord
	destroyed bool
}

func parse_particles(input string) *[]particle {
	particles := []particle{}
	particle_matcher := regexp.MustCompile(`p=<\s?(-?\d+),(-?\d+),(-?\d+)>,\ v=<\s?(-?\d+),(-?\d+),(-?\d+)>,\ a=<\s?(-?\d+),(-?\d+),(-?\d+)>`)

	for _, line := range strings.Split(input, "\n") {
		args := particle_matcher.FindAllStringSubmatch(line, -1)

		int_args := []int{}
		for i := len(args[0]) - 9; i < len(args[0]); i++ {
			int, _ := strconv.Atoi(args[0][i])
			int_args = append(int_args, int)
		}

		particle := particle{p: coord{x: int_args[0], y: int_args[1], z: int_args[2]}, v: coord{x: int_args[3], y: int_args[4], z: int_args[5]}, a: coord{x: int_args[6], y: int_args[7], z: int_args[8]}}
		particles = append(particles, particle)
	}

	return &particles
}

func z_buffer(particles *[]particle) int {
	t := 100
	scores := []int{}

	for i := 0; i < len(*particles); i++ {
		score := (*particles)[i].p.x + (*particles)[i].p.y + (*particles)[i].p.z + (*particles)[i].v.x*t + (*particles)[i].v.y*t + (*particles)[i].v.z*t + ((*particles)[i].a.x * t * (*particles)[i].a.x * t) + ((*particles)[i].a.y * t * (*particles)[i].a.y * t) + ((*particles)[i].a.z*t*(*particles)[i].a.z*t)/2
		scores = append(scores, score)
	}

	min_value := scores[0]
	min_index := 0
	for index, value := range scores {
		if value < min_value {
			min_value = value
			min_index = index
		}
	}

	return min_index
}

func count_survivors(particles *[]particle) int {
	total_steps := 1000

	for t := 0; t < total_steps; t++ {
		for i := 0; i < len(*particles); i++ {
			if (*particles)[i].destroyed {
				continue
			}

			(*particles)[i].v.x += (*particles)[i].a.x
			(*particles)[i].v.y += (*particles)[i].a.y
			(*particles)[i].v.z += (*particles)[i].a.z

			(*particles)[i].p.x += (*particles)[i].v.x
			(*particles)[i].p.y += (*particles)[i].v.y
			(*particles)[i].p.z += (*particles)[i].v.z
		}

		// order irrelevant pair generation
		for a := 0; a < len(*particles)-1; a++ {
			collision := false
			if (*particles)[a].destroyed {
				continue
			}
			for b := a + 1; b < len(*particles); b++ {
				if (*particles)[b].destroyed {
					continue
				} else if (*particles)[a].p.x == (*particles)[b].p.x && (*particles)[a].p.y == (*particles)[b].p.y && (*particles)[a].p.z == (*particles)[b].p.z {
					collision = true
					(*particles)[b].destroyed = true
				}
			}
			if collision {
				(*particles)[a].destroyed = true
			}
		}

	}

	survivors := 0
	for _, particle := range *particles {
		if particle.destroyed {
			continue
		}
		survivors += 1
	}

	return survivors
}

func main() {
	test1 := "p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>\np=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>"
	aoc.Assert_int(z_buffer(parse_particles(test1)), 0)

	test2 := "p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>\np=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>\np=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>\np=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>"
	aoc.Assert_int(count_survivors(parse_particles(test2)), 1)

	input_data := aoc.Read_file("input20.txt")
	fmt.Println(z_buffer(parse_particles(input_data)))
	fmt.Println(count_survivors(parse_particles(input_data)))
}
