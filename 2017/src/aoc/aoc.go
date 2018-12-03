package aoc

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func Read_file(file_name string) string {
	dat, err := ioutil.ReadFile(file_name)

	if err != nil {
		panic(err)
	}

	return strings.TrimSpace(string(dat))
}

func Read_file_no_trim(file_name string) string {
	dat, err := ioutil.ReadFile(file_name)

	if err != nil {
		panic(err)
	}

	return string(dat)
}

func Assert_int(a,b int) {
	if a != b {
		panic(fmt.Sprintf("Assertion failed : %d != %d", a, b))
	}
}

func Assert_str(a,b string) {
	if a != b {
		panic(fmt.Sprintf("Assertion failed : %s != %s", a, b))
	}
}

func Abs(i int) int {
	if i < 0 {
		return i * -1
	} else {
		return i
	}
}