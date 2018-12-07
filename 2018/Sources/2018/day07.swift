import Foundation

func hasNoDependances(name: Character, nodes: [(Character, [Character])]) -> Bool {
    for node in nodes {
        if node.1.contains(name) {
            return false
        }
    }

    return true
}

func 🗓0️⃣7️⃣(input: String, part2: Bool) -> String {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}

    let pattern = "^Step (\\w) must be finished before step (\\w) can begin.$"

    let regex = try! NSRegularExpression(pattern: pattern)

    var instructionArray = [(Character, Character)]()
    for string in stringArray {
        if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            let rangeA = Range(match.range(at: 1), in: string)
            let rangeB = Range(match.range(at: 2), in: string)
            instructionArray.append((Character(String(string[rangeA!])), Character(String(string[rangeB!]))))
        }

    }

    var uniqueNodes = Set<Character>()
    for uniqueNode in instructionArray {
        uniqueNodes.insert(uniqueNode.0)
        uniqueNodes.insert(uniqueNode.1)
    }

    var nodes = [(Character, [Character])]()
    for nodeName in uniqueNodes {
        var children = [Character]()
        for instruction in instructionArray.filter({$0.0 == nodeName}) {
            children.append(instruction.1)
        }
        nodes.append((nodeName, children))
    }

    nodes.sort(by: {$0.0 < $1.0})

    var orderedInstructions = ""
    while !nodes.isEmpty {
        for node in nodes {
            if hasNoDependances(name: node.0, nodes: nodes) {
                orderedInstructions.append(node.0)
                nodes.removeAll(where: {$0.0 == node.0})
                break
            }
        }
    }

    return orderedInstructions
}

let testData = "Step C must be finished before step A can begin.\nStep C must be finished before step F can begin.\nStep A must be finished before step B can begin.\nStep A must be finished before step D can begin.\nStep B must be finished before step E can begin.\nStep D must be finished before step E can begin.\nStep F must be finished before step E can begin."
assert(🗓0️⃣7️⃣(input: testData, part2: false) == "CABDFE")
// assert(🗓0️⃣7️⃣(input: testData, part2: true, part2target: 32) == 16)

let input = try String(contentsOfFile: "input07.txt")
print("🌟 :", 🗓0️⃣7️⃣(input: input, part2: false))
// print("🌟 :", 🗓0️⃣7️⃣(input: input, part2: true, part2target: 10000))
