package main

import (
	"aoc"
	"fmt"
	"strconv"
	"strings"
)

type node struct {
	name     string
	weight   int
	parent   *node
	children []*node
}

func build_tree(input string) []*node {
	nodes := []*node{}
	for _, line := range strings.Split(input, "\n") {
		split_line := strings.Split(line, " ")
		node_weight, _ := strconv.Atoi(strings.Trim(split_line[1], "()"))
		nodes = append(nodes, &node{name: split_line[0], weight: node_weight})
	}

	for index, line := range strings.Split(input, "\n") {
		split_line := strings.Split(line, " ")
		if len(split_line) > 2 {
			for i := 3; i < len(split_line); i++ {
				child_name := strings.Trim(split_line[i], ",")
				var child_index int
				var child_pointer *node
				for index, node := range nodes {
					if node.name == child_name {
						child_index = index
						child_pointer = node
						break
					}
				}
				nodes[index].children = append(nodes[index].children, child_pointer)
				nodes[child_index].parent = nodes[index]
			}
		}
	}

	return nodes
}

func find_base_node(tree []*node) *node {
	for _, node := range tree {
		if node.parent == nil {
			return node
		}
	}

	panic("no base node found!")
}

func sum_tree(node *node) int {
	sum := node.weight

	for _, child := range node.children {
		sum += sum_tree(child)
	}

	return sum
}

func find_imbalance(tree []*node, root_node *node) int {
	child_weight_map := make(map[int][]*node)

	for _, child := range root_node.children {
		sum := sum_tree(child)
		child_weight_map[sum] = append(child_weight_map[sum], child)
	}

	for _, node_list := range child_weight_map {
		if len(node_list) == 1 {
			// the imbalance is further up the tree
			return find_imbalance(tree, node_list[0])
		}
	}

	// the imbalanced node is this one
	return get_correction(tree, root_node)
}

func get_correction(tree []*node, root_node *node) int {
	child_weights := []int{}

	for _, node := range root_node.parent.children { // pointers are magic
		child_weights = append(child_weights, sum_tree(node))
	}

	unique_index := find_unique_index(child_weights)

	return root_node.weight - (child_weights[unique_index] - child_weights[(unique_index+1)%len(child_weights)])
}

// replace this, there must be a better way
func find_unique_index(values []int) int {
	for i := 0; i < len(values); i++ {
		if values[i] != values[(i+1)%len(values)] && values[i] != values[len(values)-i-1] {
			return i
		}
	}

	panic("No unique value found")
}

func main() {
	test1 := "pbga (66)\nxhth (57)\nebii (61)\nhavc (66)\nktlj (57)\nfwft (72) -> ktlj, cntj, xhth\nqoyq (66)\npadx (45) -> pbga, havc, qoyq\ntknk (41) -> ugml, padx, fwft\njptl (61)\nugml (68) -> gyxo, ebii, jptl\ngyxo (61)\ncntj (57)"
	test_tree := build_tree(test1)
	test_base_node := find_base_node(test_tree)
	aoc.Assert_str(test_base_node.name, "tknk")
	aoc.Assert_int(find_imbalance(test_tree, test_base_node), 60)

	input_data := aoc.Read_file("input07.txt")
	input_tree := build_tree(input_data)
	input_base_node := find_base_node(input_tree)
	fmt.Println(input_base_node.name)
	fmt.Println(find_imbalance(input_tree, input_base_node))

}
