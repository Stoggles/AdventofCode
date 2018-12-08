import Foundation

extension Character {
    var jobWeight: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value) - 64
        }
    }
}

func hasNoDependances(name: Character, nodes: [(Character, [Character])]) -> Bool {
    for node in nodes {
        if node.1.contains(name) {
            return false
        }
    }

    return true
}

func parseInput(input: String) -> [(Character, [Character])] {
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

    return nodes
}

func 🗓0️⃣7️⃣_part1(input: String) -> String {
    var nodes = parseInput(input: input)

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

func 🗓0️⃣7️⃣_part2(input: String, worker_count: Int, extra_job_weight: Int) -> Int {
    var nodes = parseInput(input: input)

    var steps = -1
    var jobs_in_progress = [Character: Int]()

    while !nodes.isEmpty {
        for job in jobs_in_progress.keys {
            if jobs_in_progress[job] == 1 {
                jobs_in_progress.removeValue(forKey: job)
                nodes.removeAll(where: {$0.0 == job})
            } else {
                jobs_in_progress.updateValue(jobs_in_progress[job]! - 1, forKey: job)
            }
        }
        for node in nodes {
            if jobs_in_progress.count >= worker_count {
                break
            }
            if jobs_in_progress[node.0] == nil && hasNoDependances(name: node.0, nodes: nodes) {
                jobs_in_progress[node.0] = extra_job_weight + node.0.jobWeight
            }
        }
        steps += 1
    }

    return steps
}

let testData = "Step C must be finished before step A can begin.\nStep C must be finished before step F can begin.\nStep A must be finished before step B can begin.\nStep A must be finished before step D can begin.\nStep B must be finished before step E can begin.\nStep D must be finished before step E can begin.\nStep F must be finished before step E can begin."
assert(🗓0️⃣7️⃣_part1(input: testData) == "CABDFE")
assert(🗓0️⃣7️⃣_part2(input: testData, worker_count: 2, extra_job_weight: 0) == 15)

let input = try String(contentsOfFile: "input07.txt")
print("🌟 :", 🗓0️⃣7️⃣_part1(input: input))
print("🌟 :", 🗓0️⃣7️⃣_part2(input: input, worker_count: 5, extra_job_weight: 60))
