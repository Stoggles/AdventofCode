import Foundation

func reacts(a: Character?, b: Character?) -> Bool {
    if (a == nil || b == nil) {
        return false
    }
    return a != b && String(a!).lowercased() == String(b!).lowercased()
}

func 🗓0️⃣5️⃣(input: String, part2: Bool) -> Int {
    var characterArray = [Character]()

    if part2 {
        var lowest = Int.max

        for character in Set(input.lowercased()) {
            let result = 🗓0️⃣5️⃣(input: input.filter{String($0) != String(character).lowercased()}.filter{String($0) != String(character).uppercased()}, part2: false)
            lowest = min(result, lowest)
        }
        return lowest
    }

    for character in input {
        if reacts(a: character, b: characterArray.last ?? nil) {
            characterArray.removeLast()
            continue
        }
        characterArray.append(character)
    }
    return characterArray.count
}

assert(🗓0️⃣5️⃣(input: "aA", part2: false) == 0)
assert(🗓0️⃣5️⃣(input: "abBA", part2: false) == 0)
assert(🗓0️⃣5️⃣(input: "abAB", part2: false) == 4)
assert(🗓0️⃣5️⃣(input: "aabAAB", part2: false) == 6)
assert(🗓0️⃣5️⃣(input: "dabAcCaCBAcCcaDA", part2: false) == 10)
assert(🗓0️⃣5️⃣(input: "dabAcCaCBAcCcaDA", part2: true) == 4)

let input = try String(contentsOfFile: "input05.txt").trimmingCharacters(in: .whitespacesAndNewlines)
print("🌟 :", 🗓0️⃣5️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣5️⃣(input: input, part2: true))
