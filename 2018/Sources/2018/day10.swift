import Foundation

struct Point {
    var xPos: Int
    var yPos: Int
    var xVel: Int
    var yVel: Int
}

func printArray(pointArray: inout [Point]) {
    // rewind one step to get back to the minimum total distance
    for i in 0..<pointArray.count {
        pointArray[i].xPos -= pointArray[i].xVel
        pointArray[i].yPos -= pointArray[i].yVel
    }

    let xMin = pointArray.min{a, b in a.xPos < b.xPos}!
    let xMax = pointArray.max{a, b in a.xPos < b.xPos}!
    let yMin = pointArray.min{a, b in a.yPos < b.yPos}!
    let yMax = pointArray.max{a, b in a.yPos < b.yPos}!

    for y in yMin.yPos - 1..<yMax.yPos + 1 {
        for x in xMin.xPos - 1..<xMax.xPos + 1 {
            if pointArray.filter({ $0.xPos == x && $0.yPos == y}).isEmpty {
                print(" ", separator: "", terminator:"")
            } else {
                print("X", separator: "", terminator:"")
            }
        }
        print("")
    }
}

func 🗓1️⃣0️⃣(input: String) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}

    let pattern = "^position=<\\s?(-?\\d+),\\s+(-?\\d+)> velocity=<\\s?(-?\\d+),\\s+(-?\\d+)>$"
    let regex = try! NSRegularExpression(pattern: pattern)

    var pointArray = [Point]()
    for string in stringArray {
        if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            pointArray.append(Point(xPos: Int(string[Range(match.range(at: 1), in: string)!])!,
                                    yPos: Int(string[Range(match.range(at: 2), in: string)!])!,
                                    xVel: Int(string[Range(match.range(at: 3), in: string)!])!,
                                    yVel: Int(string[Range(match.range(at: 4), in: string)!])!))
        }
    }

    var steps = 0
    var previousDistance = Int.max
    while true {
        for i in 0..<pointArray.count {
            pointArray[i].xPos += pointArray[i].xVel
            pointArray[i].yPos += pointArray[i].yVel
        }
        var totalDistance = 0
        for i in 0..<pointArray.count {
            for j in i+1..<pointArray.count {
                let a = pointArray[i]
                let b = pointArray[j]
                totalDistance += abs(a.xPos - b.xPos) + abs(a.yPos - b.yPos)
            }
        }
        if totalDistance > previousDistance {
            break
        } else {
            previousDistance = totalDistance
        }
        steps += 1
    }

    printArray(pointArray: &pointArray)

    return steps
}

let testData = "position=< 9,  1> velocity=< 0,  2>\nposition=< 7,  0> velocity=<-1,  0>\nposition=< 3, -2> velocity=<-1,  1>\nposition=< 6, 10> velocity=<-2, -1>\nposition=< 2, -4> velocity=< 2,  2>\nposition=<-6, 10> velocity=< 2, -2>\nposition=< 1,  8> velocity=< 1, -1>\nposition=< 1,  7> velocity=< 1,  0>\nposition=<-3, 11> velocity=< 1, -2>\nposition=< 7,  6> velocity=<-1, -1>\nposition=<-2,  3> velocity=< 1,  0>\nposition=<-4,  3> velocity=< 2,  0>\nposition=<10, -3> velocity=<-1,  1>\nposition=< 5, 11> velocity=< 1, -2>\nposition=< 4,  7> velocity=< 0, -1>\nposition=< 8, -2> velocity=< 0,  1>\nposition=<15,  0> velocity=<-2,  0>\nposition=< 1,  6> velocity=< 1,  0>\nposition=< 8,  9> velocity=< 0, -1>\nposition=< 3,  3> velocity=<-1,  1>\nposition=< 0,  5> velocity=< 0, -1>\nposition=<-2,  2> velocity=< 2,  0>\nposition=< 5, -2> velocity=< 1,  2>\nposition=< 1,  4> velocity=< 2,  1>\nposition=<-2,  7> velocity=< 2, -2>\nposition=< 3,  6> velocity=<-1, -1>\nposition=< 5,  0> velocity=< 1,  0>\nposition=<-6,  0> velocity=< 2,  0>\nposition=< 5,  9> velocity=< 1, -2>\nposition=<14,  7> velocity=<-2,  0>\nposition=<-3,  6> velocity=< 2, -1>"
assert(🗓1️⃣0️⃣(input: testData) == 3)

let input = try String(contentsOfFile: "input10.txt")
print("🌟 :", 🗓1️⃣0️⃣(input: input))
