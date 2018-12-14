import Foundation

func 🗓1️⃣4️⃣(input: String, part2: Bool) -> String {

    let inputInt = Int(input)!
    let inputIntArray = Array(input).map{Int(String($0))!}

    var scoreArray = [3, 7]
    var pointer1 = 0;
    var pointer2 = 1

    var i = 0
    while true {
        let score = scoreArray[pointer1] + scoreArray[pointer2]

        if score / 10 > 0 {
            scoreArray.append(score / 10)
        }
        scoreArray.append(score % 10)

        pointer1 = (pointer1 + 1 + scoreArray[pointer1]) % scoreArray.count
        pointer2 = (pointer2 + 1 + scoreArray[pointer2]) % scoreArray.count

        if part2 {
            if scoreArray.suffix(inputIntArray.count) == inputIntArray[...] {
                return String(scoreArray.count - inputIntArray.count)
            }

            if scoreArray[max(0, scoreArray.count - inputIntArray.count - 1)..<scoreArray.count - 1] == inputIntArray[...] {
                return String(scoreArray.count - inputIntArray.count - 1)
            }
        } else if i == inputInt+10 {
            return Array(scoreArray[inputInt..<inputInt+10]).compactMap{String(Int($0))}.joined()
        }
        i += 1
    }
}

assert(🗓1️⃣4️⃣(input: "5", part2: false) == "0124515891")
assert(🗓1️⃣4️⃣(input: "18", part2: false) == "9251071085")
assert(🗓1️⃣4️⃣(input: "2018", part2: false) == "5941429882")

assert(🗓1️⃣4️⃣(input: "51589", part2: true) == "9")
assert(🗓1️⃣4️⃣(input: "01245", part2: true) == "5")
assert(🗓1️⃣4️⃣(input: "92510", part2: true) == "18")
assert(🗓1️⃣4️⃣(input: "59414", part2: true) == "2018")

let input = "084601"
print("🌟 :", 🗓1️⃣4️⃣(input: input, part2: false))
print("🌟 :", 🗓1️⃣4️⃣(input: input, part2: true))
