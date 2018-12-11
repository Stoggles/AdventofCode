import Foundation

struct Coordinate: Hashable {
    var x: Int
    var y: Int
    var sampleSize: Int?

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    init(_ x: Int, _ y: Int, _ sampleSize: Int) {
        self.x = x
        self.y = y
        self.sampleSize = sampleSize
    }
}

func powerLevel(coord: Coordinate, serialNumber: Int) -> Int {
    let rackId = coord.x + 10
    return (rackId * coord.y + serialNumber) * rackId / 100 % 10 - 5
}

func 🗓1️⃣1️⃣(serialNumber: Int, part2: Bool) -> Coordinate {
    var summedAreaGrid = [Coordinate: Int]()

    for x in 1..<301 {
        for y in 1..<301 {
            let coord = Coordinate(x, y)
            var summedArea = powerLevel(coord: coord, serialNumber: serialNumber)
            summedArea += (summedAreaGrid[Coordinate(x, y - 1)] ?? 0)
            summedArea += (summedAreaGrid[Coordinate(x - 1, y)] ?? 0)
            summedArea -= (summedAreaGrid[Coordinate(x - 1, y - 1)] ?? 0)
            summedAreaGrid[coord] = summedArea
        }
    }

    var minSampleSize = 3
    var maxSampleSize = 4
    if part2 {
        minSampleSize = 1
        maxSampleSize = 301
    }

    var maxTotalPower = 0
    var maxCoordinate = Coordinate(0, 0)
    for sampleSize in minSampleSize..<maxSampleSize {
        for x in 1..<301 {
            for y in 1..<301 {
                var localTotalPower = 0
                localTotalPower += (summedAreaGrid[Coordinate(x, y)] ?? 0)
                localTotalPower -= (summedAreaGrid[Coordinate(x - sampleSize, y)] ?? 0)
                localTotalPower -= (summedAreaGrid[Coordinate(x, y - sampleSize)] ?? 0)
                localTotalPower += (summedAreaGrid[Coordinate(x - sampleSize, y - sampleSize)] ?? 0)
                if localTotalPower > maxTotalPower {
                    maxTotalPower = localTotalPower
                    maxCoordinate = Coordinate(x - sampleSize + 1, y - sampleSize + 1, sampleSize)
                }
            }
        }
    }

    return maxCoordinate
}

assert(powerLevel(coord: Coordinate(3, 5), serialNumber: 8) == 4)
assert(powerLevel(coord: Coordinate(122, 79), serialNumber: 57) == -5)
assert(powerLevel(coord: Coordinate(217, 196), serialNumber: 39) == 0)
assert(powerLevel(coord: Coordinate(101, 153), serialNumber: 71) == 4)

assert(🗓1️⃣1️⃣(serialNumber: 18, part2: false) == Coordinate(33, 45, 3))
assert(🗓1️⃣1️⃣(serialNumber: 42, part2: false) == Coordinate(21, 61, 3))

assert(🗓1️⃣1️⃣(serialNumber: 18, part2: true) == Coordinate(90, 269, 16))
assert(🗓1️⃣1️⃣(serialNumber: 42, part2: true) == Coordinate(232, 251, 12))

let input = 3628
print("🌟 :", 🗓1️⃣1️⃣(serialNumber: input, part2: false))
print("🌟 :", 🗓1️⃣1️⃣(serialNumber: input, part2: true))
