import Foundation

struct Operation {
    let initState: [Int]
    let operands: [Int]
    let finalState: [Int]

    public init(_ initState: [Int], _ operands: [Int], _ finalState: [Int]) {
        self.initState = initState
        self.operands = operands
        self.finalState = finalState
    }
}

// 1
func addr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] + registers[operands[2]]
    return result
}

// 3
func addi(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] + operands[2]
    return result
}

// 7
func mulr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] * registers[operands[2]]
    return result
}

// 10
func muli(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] * operands[2]
    return result
}

// 11
func banr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] & registers[operands[2]]
    return result
}

// 14
func bani(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] & operands[2]
    return result
}

// 0
func borr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] | registers[operands[2]]
    return result
}

// 15
func bori(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]] | operands[2]
    return result
}

// 8
func setr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = registers[operands[1]]
    return result
}

// 12
func seti(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = operands[1]
    return result
}

// 9
func gtir(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = (operands[1] > registers[operands[2]] ? 1 : 0)
    return result
}

// 6
func gtri(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = (registers[operands[1]] > operands[2] ? 1 : 0)
    return result
}

// 13
func gtrr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = (registers[operands[1]] > registers[operands[2]] ? 1 : 0)
    return result
}

// 5
func eqir(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = (operands[1] == registers[operands[2]] ? 1 : 0)
    return result
}

// 4
func eqri(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = (registers[operands[1]] == operands[2] ? 1 : 0)
    return result
}

// 2
func eqrr(_ operands: [Int], _ registers: [Int]) -> [Int] {
    var result = registers
    result[operands[3]] = (registers[operands[1]] == registers[operands[2]] ? 1 : 0)
    return result
}

func 🗓1️⃣6️⃣_part1(input: String) -> Int {
    let pattern = "Before: \\[(\\d+, \\d+, \\d+, \\d+)\\]\\n(\\d+ \\d+ \\d+ \\d+)\\nAfter:  \\[(\\d+, \\d+, \\d+, \\d+)\\]"
    let regex = try! NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))

    var operationsArray = [Operation]()
    for match in matches {
        operationsArray.append(Operation(
            String(input[Range(match.range(at: 1), in: input)!]).split(separator: ",").compactMap{Int($0.trimmingCharacters(in: .whitespacesAndNewlines))},
            String(input[Range(match.range(at: 2), in: input)!]).split(separator: " ").compactMap{Int($0)},
            String(input[Range(match.range(at: 3), in: input)!]).split(separator: ",").compactMap{Int($0.trimmingCharacters(in: .whitespacesAndNewlines))}
        ))
    }

    var result = 0
    var matchingOpCodes = [Int: Set<String>]()
    for i in 0..<16 {
        matchingOpCodes[i] = Set<String>()
    }
    for i in 0..<operationsArray.count {
        var matchingOperationCount = 0
        if addr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("addr")
        }
        if addi(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("addi")
        }
        if mulr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("mulr")
        }
        if muli(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("muli")
        }
        if banr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("banr")
        }
        if bani(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("bani")
        }
        if borr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("borr")
        }
        if bori(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("bori")
        }
        if setr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("setr")
        }
        if seti(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("seti")
        }
        if gtir(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("gtir")
        }
        if gtri(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("gtri")
        }
        if gtrr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("gtrr")
        }
        if eqir(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("eqir")
        }
        if eqri(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("eqri")
        }
        if eqrr(operationsArray[i].operands, operationsArray[i].initState) == operationsArray[i].finalState {
            matchingOperationCount += 1
            matchingOpCodes[operationsArray[i].operands[0]]!.insert("eqrr")
        }
        if matchingOperationCount >= 3 {
            result += 1
        }
    }

    var opCodes = [Int: String]()

    outer: while matchingOpCodes.map({$0.1.count > 1}).count > 0 {
        for i in matchingOpCodes.keys {
            if matchingOpCodes[i]!.count == 1 {
                let fieldToRemove = matchingOpCodes[i]!.first!
                let indexToRemove = i
                for j in matchingOpCodes.keys {
                    if matchingOpCodes[j]!.count > 1 {
                        matchingOpCodes[j]!.remove(fieldToRemove)
                    }
                }
                opCodes[indexToRemove] = matchingOpCodes[indexToRemove]!.first!
                matchingOpCodes.removeValue(forKey: indexToRemove)
            }
        }
    }

    for key in opCodes.keys.sorted() {
        print(key, opCodes[key]!)
    }

    return result
}

func 🗓1️⃣6️⃣_part2(input: String) -> Int {
    let pattern = "(\\d+ \\d+ \\d+ \\d+(?!\\nAfter))"
    let regex = try! NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))

    var instructions = [[Int]]()
    for match in matches {
        instructions.append(String(input[Range(match.range(at: 1), in: input)!]).split(separator: " ").compactMap{Int($0)})
    }

    var registers = [0, 0, 0, 0]

    for instruction in instructions {
        switch instruction[0] {
            case 0:
                registers = borr(instruction, registers)
            case 1:
                registers = addr(instruction, registers)
            case 2:
                registers = eqrr(instruction, registers)
            case 3:
                registers = addi(instruction, registers)
            case 4:
                registers = eqri(instruction, registers)
            case 5:
                registers = eqir(instruction, registers)
            case 6:
                registers = gtri(instruction, registers)
            case 7:
                registers = mulr(instruction, registers)
            case 8:
                registers = setr(instruction, registers)
            case 9:
                registers = gtir(instruction, registers)
            case 10:
                registers = muli(instruction, registers)
            case 11:
                registers = banr(instruction, registers)
            case 12:
                registers = seti(instruction, registers)
            case 13:
                registers = gtrr(instruction, registers)
            case 14:
                registers = bani(instruction, registers)
            case 15:
                registers = bori(instruction, registers)
            default:
                continue
        }
    }

    return registers[0]
}

let input = try String(contentsOfFile: "input16.txt")
print("🌟 :", 🗓1️⃣6️⃣_part1(input: input))
print("🌟 :", 🗓1️⃣6️⃣_part2(input: input))
