import Foundation

func 🗓0️⃣2️⃣_part1(input: String) -> Int {
    let stringArray = input.split(separator: "\n")

    var count2 = 0, count3 = 0

    for id in stringArray {
        var characterCount = [Character: Int]()
            for character in id {
                characterCount[character] = (characterCount[character] ?? 0) + 1
            }
        
        let counts = Array(characterCount.values)

        if counts.contains(2) {
            count2 += 1
        }
        if counts.contains(3) {
            count3 += 1
        }
    }
    return count2 * count3
}

func 🗓0️⃣2️⃣_part2(input: String) -> String {
    let stringArray = input.split(separator: "\n")
    
    for stringIndex1 in 0..<stringArray.count {
        for stringIndex2 in stringIndex1+1..<stringArray.count {
            let differences = zip(stringArray[stringIndex1], stringArray[stringIndex2]).filter{ $0 != $1 }

            if differences.count == 1 {
                return stringArray[stringIndex1].filter{ $0 != differences[0].0 }
            }
        }
    }

    return "failure"
}

assert(🗓0️⃣2️⃣_part1(input: "abcdef\nbababc\nabbcde\nabcccd\naabcdd\nabcdee\nababab") == 12)
assert(🗓0️⃣2️⃣_part2(input: "abcde\nfghij\nklmno\npqrst\nfguij\naxcye\nwvxyz") == "fgij")

let input = try String(contentsOfFile: "input02.txt")
print("🌟 :", 🗓0️⃣2️⃣_part1(input: input))
print("🌟 :", 🗓0️⃣2️⃣_part2(input: input))
