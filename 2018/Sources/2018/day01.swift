import Foundation

func 🗓0️⃣1️⃣(input: String, part2: Bool) -> Int {
    let valueArray = input.split(separator: "\n").compactMap{Int($0)}

    if part2 {
        var sum = 0
        var frequencyCount = [Int: Int]()

        frequencyCount[sum] = 1

        while true {
            for frequency in valueArray {
                sum += frequency
                if frequencyCount[sum] != nil {
                    return sum
                } else {
                    frequencyCount[sum] = 1
                }
            }
        }
    } else {
        return valueArray.reduce(0, +)
    }
}

assert(🗓0️⃣1️⃣(input: "+1\n+1\n+1", part2: false) == 3)
assert(🗓0️⃣1️⃣(input: "+1\n+1\n-2", part2: false) == 0)
assert(🗓0️⃣1️⃣(input: "-1\n-2\n-3", part2: false) == -6)

assert(🗓0️⃣1️⃣(input: "+1\n-1", part2: true) == 0)
assert(🗓0️⃣1️⃣(input: "+3\n+3\n+4\n-2\n-4", part2: true) == 10)
assert(🗓0️⃣1️⃣(input: "-6\n+3\n+8\n+5\n-6", part2: true) == 5)
assert(🗓0️⃣1️⃣(input: "+7\n+7\n-2\n-7\n-4", part2: true) == 14)

let input = try String(contentsOfFile: "input01.txt")
print("🌟 :", 🗓0️⃣1️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣1️⃣(input: input, part2: true))
