import Foundation

func shellMax(shell: Int) -> Int{
    return (pow(Decimal(shell*2 + 1), 2) as NSDecimalNumber).intValue
}

func 🗓0️⃣3️⃣(target: Int, part2: Bool) -> Int {

    var shell = 0

    while target > shellMax(shell: shell) {
        shell += 1
    }

    if shell == 0 {
        return 0
    }

    let stepsFromCorner = (shellMax(shell: shell) - target) % (shell * 2)

    return shell + abs(stepsFromCorner - shell)
}

assert(🗓0️⃣3️⃣(target: 1, part2: false) == 0)
assert(🗓0️⃣3️⃣(target: 12, part2: false) == 3)
assert(🗓0️⃣3️⃣(target: 23, part2: false) == 2)
assert(🗓0️⃣3️⃣(target: 1024, part2: false) == 31)

let input = 265149
print("🌟 :", 🗓0️⃣3️⃣(target: input, part2: false))
// print("🌟 :", 🗓0️⃣3️⃣(input: input, part2: true))
