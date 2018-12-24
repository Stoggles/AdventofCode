import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    static func +(left: Point, right: Point) -> Point {
        return Point(left.x + right.x, left.y + right.y)
    }
}

func waterRecursion(startPoint: Point, map: inout [Point: Character]) {
    let yMax = map.keys.sorted{$0.y > $1.y}[0].y

    var currentPoint = startPoint
    var count = map.filter({["|", "~"].contains($0.value)}).count

    outer: while true {
        // drip down for as long as possible
        while !["#", "~"].contains(map[currentPoint + Point(0, 1)]) {
            if currentPoint.y > yMax {
                break outer
            }
            map[currentPoint] = "|"
            currentPoint = currentPoint + Point(0, 1)
        }

        map[currentPoint] = "|"

        // now this must be a surface
        var leftWall = false
        var leftWallPosition = 1
        while true {
            if map[currentPoint + Point(-leftWallPosition, 0)] == "#" {
                leftWall = true
                break
            } else {
                map[currentPoint + Point(-leftWallPosition, 0)] = "|"
                if ["#", "~"].contains(map[currentPoint + Point(-leftWallPosition, 1)]) { // if a floor is present, keep spreading
                    leftWallPosition += 1
                    continue
                } else if map[currentPoint + Point(-leftWallPosition, 1)] != "|" { // if it hasn't already spilled over this edge
                    waterRecursion(startPoint: currentPoint + Point(-leftWallPosition, 0), map: &map)
                    continue
                }
                break
            }
        }

        var rightWall = false
        var rightWallPosition = 1
        while true {
            if map[currentPoint + Point(rightWallPosition, 0)] == "#" {
                rightWall = true
                break
            } else {
                map[currentPoint + Point(rightWallPosition, 0)] = "|"
                if ["#", "~"].contains(map[currentPoint + Point(rightWallPosition, 1)]) { // if a floor is present, keep spreading
                    rightWallPosition += 1
                    continue
                } else if map[currentPoint + Point(rightWallPosition, 1)] != "|" { // if it hasn't already spilled over this edge
                    waterRecursion(startPoint: currentPoint + Point(rightWallPosition, 0), map: &map)
                    continue
                }
                break
            }
        }

        if leftWall && rightWall {
            for x in -leftWallPosition+1...rightWallPosition-1 {
                map[currentPoint + Point(x, 0)] = "~"
            }
        }
        // start again
        currentPoint = startPoint

        for y in startPoint.y-2...startPoint.y+20 {
            for x in startPoint.x-20...startPoint.x+20 {
                print(map[Point(x, y)] ?? ".", separator: "", terminator:"")
            }
            print("")
        }
        print("")
        // sleep(1)

        let newCount = map.filter({["|", "~"].contains($0.value)}).count
        if newCount > count {
            count = newCount
            continue
        } else {
            break outer
        }
    }
}

func 🗓1️⃣7️⃣(input: String, part2: Bool) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}

    let patternX = "x=(\\d+)(?:\\.\\.(\\d+))?"
    let patternY = "y=(\\d+)(?:\\.\\.(\\d+))?"
    let regexX = try! NSRegularExpression(pattern: patternX)
    let regexY = try! NSRegularExpression(pattern: patternY)

    var map = [Point: Character]()
    for string in stringArray {
        let matchX = regexX.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
        let matchY = regexY.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))

        let x1 = Int(string[Range(matchX!.range(at: 1), in: string)!])!
        let x2 = Int(string[Range(matchX!.range(at: 2), in: string) ?? Range(matchX!.range(at: 1), in: string)!])!
        let y1 = Int(string[Range(matchY!.range(at: 1), in: string)!])!
        let y2 = Int(string[Range(matchY!.range(at: 2), in: string) ?? Range(matchY!.range(at: 1), in: string)!])!

        for x in x1...x2 {
            for y in y1...y2 {
                map[Point(x, y)] = "#"
            }
        }
    }

    map[Point(500,0)] = "+"

    waterRecursion(startPoint: Point(500, 1), map: &map)

    return map.filter({["|", "~"].contains($0.value)}).count
}

let testData = "x=495, y=2..7\ny=7, x=495..501\nx=501, y=3..7\nx=498, y=2..4\nx=506, y=1..2\nx=498, y=10..13\nx=504, y=10..13\ny=13, x=498..504"
// assert(🗓1️⃣7️⃣(input: testData, part2: false) == 57)

let input = try String(contentsOfFile: "input17.txt")
print("🌟 :", 🗓1️⃣7️⃣(input: input, part2: false))
// print("🌟 :", 🗓1️⃣7️⃣_part2(input: input))
