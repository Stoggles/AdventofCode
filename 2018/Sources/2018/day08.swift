import Foundation

struct Node {
    var children: [Node]
    var metadata: [Int]
}

func buildNode(inputArray: [Int], pointer: inout Int) -> Node {
    let childrenCount = inputArray[pointer]
    pointer += 1
    let metadataCount = inputArray[pointer]
    pointer += 1

    var newNode = Node(children: [Node](), metadata: [Int]())
    for _ in 0..<childrenCount {
        newNode.children.append(buildNode(inputArray: inputArray, pointer: &pointer))
    }
    for _ in 0..<metadataCount {
        newNode.metadata.append(inputArray[pointer])
        pointer += 1
    }

    return newNode
}

func firstCheck(node: Node, runningTotal: inout Int) {
    for child in node.children {
        firstCheck(node: child, runningTotal: &runningTotal)
    }

    runningTotal += node.metadata.reduce(0, +)
}

func secondCheck(node: Node, runningTotal: inout Int) {
    if node.children.isEmpty {
        runningTotal += node.metadata.reduce(0, +)
    } else {
        for index in node.metadata {
            if index > 0 && index <= node.children.count {
                secondCheck(node: node.children[index - 1], runningTotal: &runningTotal)
            }
        }
    }
}

func 🗓0️⃣8️⃣(input: String, part2: Bool) -> Int {
    let inputArray = input.split(separator: " ").compactMap{Int($0)}

    var pointer = 0
    let rootNode = buildNode(inputArray: inputArray, pointer: &pointer)

    var result = 0
    if part2 {
        secondCheck(node: rootNode, runningTotal: &result)
    } else {
        firstCheck(node: rootNode, runningTotal: &result)
    }

    return result
}

let testData = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
assert(🗓0️⃣8️⃣(input: testData, part2: false) == 138)
assert(🗓0️⃣8️⃣(input: testData, part2: true) == 66)

let input = try String(contentsOfFile: "input08.txt")
print("🌟 :", 🗓0️⃣8️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣8️⃣(input: input, part2: true))
