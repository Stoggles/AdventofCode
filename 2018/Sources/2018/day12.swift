import Foundation

func toInt(_ input: [Character]) -> Int {
    var result = 0
    if input[0] == "#" {
        result += 16
    }
    if input[1] == "#" {
        result += 8
    }
    if input[2] == "#" {
        result += 4
    }
    if input[3] == "#" {
        result += 2
    }
    if input[4] == "#" {
        result += 1
    }
    return result
}

func 🗓1️⃣2️⃣(input: String, part2: Bool) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}

    let initalState = String(stringArray[0].split(separator: " ")[2])
    var growthMap = [Int: Character]()
    var potMapA = [Int: Character]()
    var potMapB = [Int: Character]()

    for i in 0..<initalState.count {
        potMapA[i] = initalState[initalState.index(initalState.startIndex, offsetBy: i)]
    }

    let pattern = "^([.#]{5}) => ([.#])$"
    let regex = try! NSRegularExpression(pattern: pattern)
    for string in stringArray[1...] {
        if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            let charArray = string[Range(match.range(at: 1), in: input)!].compactMap{$0}
            growthMap[toInt(charArray)] = Character(String(string[Range(match.range(at: 2), in: string)!]))
        }
    }

    let iterations = part2 ? 94 : 20

    for _ in 0..<iterations {
        for j in potMapA.keys.min()! - 1..<potMapA.keys.max()! + 2 {
            var growthArray = [Character]()
            for k in j-2..<j+3 {
                growthArray.append(potMapA[k] ?? ".")
            }
            potMapB[j] = (growthMap[toInt(growthArray)] ?? ".")
        }
        swap(&potMapA, &potMapB)
    }

    var result = potMapA.filter{$0.value == "#"}.keys.reduce(0, +)
    if part2 {
        result += (22 * (50000000000 - iterations))
    }

    return result
}

let testData = "initial state: #..#.#..##......###...###\n\n...## => #\n..#.. => #\n.#... => #\n.#.#. => #\n.#.## => #\n.##.. => #\n.#### => #\n#.#.# => #\n#.### => #\n##.#. => #\n##.## => #\n###.. => #\n###.# => #\n####. => #"
assert(🗓1️⃣2️⃣(input: testData, part2: false) == 325)

let input = try String(contentsOfFile: "input12.txt")
print("🌟 :", 🗓1️⃣2️⃣(input: input, part2: false))
print("🌟 :", 🗓1️⃣2️⃣(input: input, part2: true))
