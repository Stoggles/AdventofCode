import Foundation

struct Coordinate: Hashable {
    var x: Int
    var y: Int
}

func manhattanDistance(a: Coordinate, b: Coordinate) -> Int {
    return abs(a.x - b.x) + abs(a.y - b.y)
}

func 🗓0️⃣6️⃣(input: String, part2: Bool, part2region: Int) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}

    let pattern = "^(\\d+), (\\d+)$"
    let regex = try! NSRegularExpression(pattern: pattern)

    var coordinateMap = [Int: Coordinate]()
    for i in 0..<stringArray.count {
        var x = 0, y = 0
        if let match = regex.firstMatch(in: stringArray[i], options: [], range: NSRange(location: 0, length: stringArray[i].count)) {
            if let range = Range(match.range(at: 1), in: stringArray[i]) {
                x = Int(stringArray[i][range])!
            }
            if let range = Range(match.range(at: 2), in: stringArray[i]) {
                y = Int(stringArray[i][range])!
            }
        }
        coordinateMap[i] = Coordinate(x: x, y: y)
    }

    let xMin = coordinateMap.min{a, b in a.value.x < b.value.x}!.value.x
    let xMax = coordinateMap.max{a, b in a.value.x < b.value.x}!.value.x
    let yMin = coordinateMap.min{a, b in a.value.y < b.value.y}!.value.y
    let yMax = coordinateMap.max{a, b in a.value.y < b.value.y}!.value.y

    var grid = [Coordinate: Int]()
    for x in xMin..<xMax {
        for y in yMin..<yMax {
            let coord = Coordinate(x: x, y: y)
            var closestDistance = Int.max
            var closestCoord = Int.max
            var tie = false
            var sum = 0
            for (name, targetCoord) in coordinateMap {
                let distance = manhattanDistance(a: coord, b: targetCoord)
                if part2 {
                    sum += distance
                } else if distance == closestDistance {
                    tie = true
                } else if distance < closestDistance {
                    closestDistance = distance
                    closestCoord = name
                    tie = false
                }
            }
            if part2 {
                grid[coord] = sum
            } else {
                grid[coord] = tie ? nil : closestCoord
            }

        }
    }

    if part2 {
        return grid.values.filter{ $0 < part2region}.count
    } else {
        return grid.values.reduce(into: [:]){$0[$1, default: 0] += 1}.values.max()!
    }
}

let testData = "1, 1\n1, 6\n8, 3\n3, 4\n5, 5\n8, 9"
assert(🗓0️⃣6️⃣(input: testData, part2: false, part2region: 0) == 17)
assert(🗓0️⃣6️⃣(input: testData, part2: true, part2region: 32) == 16)

let input = try String(contentsOfFile: "input06.txt")
print("🌟 :", 🗓0️⃣6️⃣(input: input, part2: false, part2region: 0))
print("🌟 :", 🗓0️⃣6️⃣(input: input, part2: true, part2region: 10000))
