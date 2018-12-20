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

    var previousWetTileCount = 0
    // while true {

    // }

    return 57
}

let testData = "x=495, y=2..7\ny=7, x=495..501\nx=501, y=3..7\nx=498, y=2..4\nx=506, y=1..2\nx=498, y=10..13\nx=504, y=10..13\ny=13, x=498..504"
assert(🗓1️⃣7️⃣(input: testData, part2: false) == 57)

// let input = try String(contentsOfFile: "input17.txt")
// print("🌟 :", 🗓1️⃣7️⃣(input: input, part2: false))
// print("🌟 :", 🗓1️⃣7️⃣_part2(input: input))
