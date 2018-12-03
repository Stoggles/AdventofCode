import Foundation

func 🗓0️⃣1️⃣(input: String, part2: Bool) -> Int {
    let valueArray = input.compactMap{Int(String($0))}

    var sum = 0

    for (index, value) in valueArray.enumerated() {
        var nextIndex = 0;
        if (part2) {
            nextIndex = (index + valueArray.count / 2) % valueArray.count
        } else {
            nextIndex = (index + 1) % valueArray.count
        }

        if (value == valueArray[nextIndex]) {
            sum += value
        }
    }
    
    return sum
}

assert(🗓0️⃣1️⃣(input: "1122", part2: false) == 3)
assert(🗓0️⃣1️⃣(input: "1111", part2: false) == 4)
assert(🗓0️⃣1️⃣(input: "1234", part2: false) == 0)
assert(🗓0️⃣1️⃣(input: "91212129", part2: false) == 9)

assert(🗓0️⃣1️⃣(input: "1212", part2: true) == 6)
assert(🗓0️⃣1️⃣(input: "1221", part2: true) == 0)
assert(🗓0️⃣1️⃣(input: "123425", part2: true) == 4)
assert(🗓0️⃣1️⃣(input: "123123", part2: true) == 12)
assert(🗓0️⃣1️⃣(input: "12131415", part2: true) == 4)

let input = try String(contentsOfFile: "2017-input01.txt")
print("🌟 :", 🗓0️⃣1️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣1️⃣(input: input, part2: true))
