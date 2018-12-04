import Foundation

struct Coordinate: Hashable {
    var x: Int
    var y: Int
}

var fabricMap = [Coordinate: Int]()
var claims = [[Int]]()

func 🗓0️⃣3️⃣(input: String, part2: Bool) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{ String($0) }

    let pattern = "^#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)$"
    let regex = try! NSRegularExpression(pattern: pattern)

    if part2 {
        claim: for claim in claims {
            for x in claim[1]..<claim[1]+claim[3] {
                for y in claim[2]..<claim[2]+claim[4] {
                    if fabricMap[Coordinate(x: x, y: y)]! > 1 {
                        continue claim
                    }
                }
            }
            return claim[0]
        }
    } else {
        for claim in stringArray {
            var parsedClaim = [Int]()
            if let match = regex.firstMatch(in: claim, options: [], range: NSRange(location: 0, length: claim.count)) {
                for i in 1..<6 {
                    if let range = Range(match.range(at: i), in: claim) {
                        parsedClaim.append(Int(claim[range])!)
                    }
                }
            }
            claims.append(parsedClaim)
        }

        for claim in claims {
            for x in claim[1]..<claim[1]+claim[3] {
                for y in claim[2]..<claim[2]+claim[4] {
                    let coord = Coordinate(x: x, y: y)
                    fabricMap[coord] = (fabricMap[coord] ?? 0) + 1
                }
            }
        }
    }

    return fabricMap.values.filter{$0 > 1}.count
}

let testData = "#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2"
assert(🗓0️⃣3️⃣(input: testData, part2: false) == 4)
assert(🗓0️⃣3️⃣(input: testData, part2: true) == 3)

let input = try String(contentsOfFile: "input03.txt")
print("🌟 :", 🗓0️⃣3️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣3️⃣(input: input, part2: true))
