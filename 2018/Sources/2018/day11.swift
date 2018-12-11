import Foundation

func powerLevel(x: Int, y: Int, serialNumber: Int) -> Int {
    let rackId = x + 10
    return (rackId * y + serialNumber) * rackId / 100 % 10 - 5
}

func 🗓1️⃣1️⃣(serialNumber: Int, part2: Bool) -> [Int] {
    var summedAreaGrid = Array(repeating: Array(repeating: 0, count: 301), count: 301)

    for x in 1..<301 {
        for y in 1..<301 {
            summedAreaGrid[x][y] = powerLevel(x: x, y: y, serialNumber: serialNumber)
                                 + summedAreaGrid[x][y - 1]
                                 + summedAreaGrid[x - 1][y]
                                 - summedAreaGrid[x - 1][y - 1]
        }
    }

    var minSampleSize = 3, maxSampleSize = 4
    if part2 {
        minSampleSize = 1; maxSampleSize = 301
    }

    var maxTotalPower = 0
    var maxTotalX = Int.min, maxTotalY = Int.min, maxTotalSampleSize = Int.min
    for sampleSize in minSampleSize..<maxSampleSize {
        for x in sampleSize..<301 {
            for y in sampleSize..<301 {
                let localTotalPower = summedAreaGrid[x][y]
                                    - summedAreaGrid[x - sampleSize][y]
                                    - summedAreaGrid[x][y - sampleSize]
                                    + summedAreaGrid[x - sampleSize][y - sampleSize]
                if localTotalPower > maxTotalPower {
                    maxTotalPower = localTotalPower
                    maxTotalX = x - sampleSize + 1; maxTotalY = y - sampleSize + 1; maxTotalSampleSize = sampleSize
                }
            }
        }
    }

    if part2 {
        return [maxTotalX, maxTotalY, maxTotalSampleSize]
    } else {
        return [maxTotalX, maxTotalY]
    }

}

assert(powerLevel(x: 3, y: 5, serialNumber: 8) == 4)
assert(powerLevel(x: 122, y: 79, serialNumber: 57) == -5)
assert(powerLevel(x: 217, y: 196, serialNumber: 39) == 0)
assert(powerLevel(x: 101, y: 153, serialNumber: 71) == 4)

assert(🗓1️⃣1️⃣(serialNumber: 18, part2: false) == [33, 45])
assert(🗓1️⃣1️⃣(serialNumber: 42, part2: false) == [21, 61])

assert(🗓1️⃣1️⃣(serialNumber: 18, part2: true) == [90, 269, 16])
assert(🗓1️⃣1️⃣(serialNumber: 42, part2: true) == [232, 251, 12])

let input = 3628
print("🌟 :", 🗓1️⃣1️⃣(serialNumber: input, part2: false))
print("🌟 :", 🗓1️⃣1️⃣(serialNumber: input, part2: true))
