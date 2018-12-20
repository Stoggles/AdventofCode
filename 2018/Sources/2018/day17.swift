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
    let yMin = map.keys.sorted{$0.y < $1.y}[0].y
    let yMax = map.keys.sorted{$0.y > $1.y}[0].y

    var currentPoint = startPoint
    var count = map.keys.filter({$0.y >= yMin && $0.y <= yMax}).map({map[$0]}).filter({["|", "~"].contains($0)}).count

    outer: while true {
        // skip down until we hit a surface
        while map[currentPoint + Point(0, 1)] == nil ||  map[currentPoint + Point(0, 1)] == "|" {
            if currentPoint.y > yMax {
                break outer
            }
            map[currentPoint] = "|"
            currentPoint = currentPoint + Point(0, 1)
        }

        print(currentPoint)

        if ["#", "~"].contains(map[currentPoint + Point(0, 1)]) {
            var leftWall = false
            var leftWallPosition = 1
            while true {
                if map[currentPoint + Point(-leftWallPosition, 0)] == "#" {
                    leftWall = true
                    break
                } else if ["#", "~"].contains(map[currentPoint + Point(-leftWallPosition, 1)]) {
                    map[currentPoint + Point(-leftWallPosition, 0)] = "|"
                    leftWallPosition += 1
                } else {
                    map[currentPoint + Point(-leftWallPosition, 0)] = "|"
                    waterRecursion(startPoint: currentPoint + Point(-leftWallPosition, 0), map: &map)
                    break
                }
            }

            var rightWall = false
            var rightWallPosition = 1
            while true {
                if map[currentPoint + Point(rightWallPosition, 0)] == "#" {
                    rightWall = true
                    break
                } else if ["#", "~"].contains(map[currentPoint + Point(rightWallPosition, 1)]) {
                    map[currentPoint + Point(rightWallPosition, 0)] = "|"
                    rightWallPosition += 1
                } else {
                    map[currentPoint + Point(rightWallPosition, 0)] = "|"
                    waterRecursion(startPoint: currentPoint + Point(rightWallPosition, 0), map: &map)
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
        }

        // for y in 0...yMax {
        //     for x in 490...510 {
        //         print(map[Point(x, y)] ?? ".", separator: "", terminator:"")
        //     }
        //     print("")
        // }
        // print("")
        // sleep(1)

        let newCount = map.keys.filter({$0.y >= yMin && $0.y <= yMax}).map({map[$0]}).filter({["|", "~"].contains($0)}).count
        if newCount > count {
            count = newCount
            continue
        } else {
            break
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

    let yMin = map.keys.sorted{$0.y < $1.y}[0].y
    let yMax = map.keys.sorted{$0.y > $1.y}[0].y

    map[Point(500,0)] = "+"

    waterRecursion(startPoint: Point(500, 1), map: &map)

    return map.keys.filter({$0.y >= yMin && $0.y <= yMax}).map({map[$0]}).filter({["|", "~"].contains($0)}).count
}

let testData = "x=495, y=2..7\ny=7, x=495..501\nx=501, y=3..7\nx=498, y=2..4\nx=506, y=1..2\nx=498, y=10..13\nx=504, y=10..13\ny=13, x=498..504"
assert(🗓1️⃣7️⃣(input: testData, part2: false) == 57)

let input = try String(contentsOfFile: "input17.txt")
// print("🌟 :", 🗓1️⃣7️⃣(input: input, part2: false))
// print("🌟 :", 🗓1️⃣7️⃣_part2(input: input))
