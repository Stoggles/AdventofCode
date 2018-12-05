import Foundation

func reacts(a: Character, b: Character) -> Bool {
    return a != b && String(a).lowercased() == String(b).lowercased()
}

func 🗓0️⃣5️⃣(input: String, part2: Bool) -> Int {
    var characterArray = [Character]()

    for character in input.trimmingCharacters(in: .whitespacesAndNewlines) {
        if characterArray.last != nil && reacts(a: character, b: characterArray.last!) {
            characterArray.removeLast()
            continue
        }
        characterArray.append(character)
    }
    return String(characterArray).count
}

assert(🗓0️⃣5️⃣(input: "aA", part2: false) == 0)
assert(🗓0️⃣5️⃣(input: "abBA", part2: false) == 0)
assert(🗓0️⃣5️⃣(input: "abAB", part2: false) == 4)
assert(🗓0️⃣5️⃣(input: "aabAAB", part2: false) == 6)
assert(🗓0️⃣5️⃣(input: "dabAcCaCBAcCcaDA", part2: false) == 10)

let input = try String(contentsOfFile: "input05.txt")
print("🌟 :", 🗓0️⃣5️⃣(input: input, part2: false))
// print("🌟 :", 🗓0️⃣5️⃣(input: input, part2: true))
