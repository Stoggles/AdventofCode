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

enum Turn {
    case left
    case right
    case straight
}

struct Cart {
    var position: Point
    var direction: Point
    var nextTurn: Turn
    var crashed: Bool

    public init(_ position: Point, _ direction: Point) {
        self.position = position
        self.direction = direction
        self.nextTurn = Turn.left
        self.crashed = false
    }

    mutating func turn() {
        switch self.nextTurn {
            case Turn.left:
                self.direction = Point(self.direction.y, self.direction.x * -1)
                self.nextTurn = Turn.straight
            case Turn.right:
                self.direction = Point(self.direction.y * -1, self.direction.x)
                self.nextTurn = Turn.left
            case Turn.straight:
                self.nextTurn = Turn.right
        }
    }

    mutating func forwardslash() {
        switch self.direction {
            case Point(1, 0):
                self.direction = Point(0, -1)
            case Point(-1, 0):
                self.direction = Point(0, 1)
            case Point(0, 1):
                self.direction = Point(-1, 0)
            case Point(0, -1):
                self.direction = Point(1, 0)
            default:
                break
        }
    }

    mutating func backslach() {
        switch self.direction {
            case Point(1, 0):
                self.direction = Point(0, 1)
            case Point(-1, 0):
                self.direction = Point(0, -1)
            case Point(0, 1):
                self.direction = Point(1, 0)
            case Point(0, -1):
                self.direction = Point(-1, 0)
            default:
                break
        }
    }
}

func 🗓1️⃣3️⃣(input: String, part2: Bool) -> Point {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}

    var map = [Point: Character]()
    var cartArray = [Cart]()
    var cartCount = 0

    for y in 0..<stringArray.count {
        for x in 0..<stringArray[y].count {
            var char = stringArray[y][stringArray[y].index(stringArray[y].startIndex, offsetBy: x)]
            switch char {
                case " ": // ensure the map does not contain the empty space
                    continue
                case ">":
                    cartArray.append(Cart(Point(x, y), Point(1, 0)))
                    cartCount += 1
                    char = "-"
                case "<":
                    cartArray.append(Cart(Point(x, y), Point(-1, 0)))
                    cartCount += 1
                    char = "-"
                case "^":
                    cartArray.append(Cart(Point(x, y), Point(0, -1)))
                    cartCount += 1
                    char = "|"
                case "v":
                    cartArray.append(Cart(Point(x, y), Point(0, 1)))
                    cartCount += 1
                    char = "|"
                default:
                    break
            }
            map[Point(x, y)] = char
        }
    }

    while true {
        if cartCount == 1 {
            return cartArray.filter({!$0.crashed})[0].position
        }
        cart: for i in 0..<cartArray.count {
            if cartArray[i].crashed {
                continue
            }
            cartArray[i].position = cartArray[i].position + cartArray[i].direction
            assert(map[cartArray[i].position] != nil)
            switch map[cartArray[i].position] {
                case "+":
                    cartArray[i].turn()
                case "/":
                    cartArray[i].forwardslash()
                case "\\":
                    cartArray[i].backslach()
                default:
                    break
            }

            for j in 0..<cartArray.count {
                if i == j || cartArray[j].crashed {
                    continue
                } else if cartArray[i].position == cartArray[j].position {
                    if part2 {
                        cartArray[i].crashed = true; cartArray[j].crashed = true
                        cartCount -= 2
                        continue cart
                    } else {
                        return cartArray[i].position
                    }
                }
            }
        }

        cartArray.sort{
            if $0.position.x != $1.position.y {
                return $0.position.x < $1.position.x
            } else {
                return $0.position.y < $1.position.y
            }
        }
    }
}

let testData = "/->-\\\n|   |  /----\\\n| /-+--+-\\  |\n| | |  | v  |\n\\-+-/  \\-+--/\n  \\------/"
let testData2 = "/>-<\\  \n|   |  \n| /<+-\\\n| | | v\n\\>+</ |\n  |   ^\n  \\<->/"
assert(🗓1️⃣3️⃣(input: testData, part2: false) == Point(7, 3))
assert(🗓1️⃣3️⃣(input: testData2, part2: true) == Point(6, 4))

let input = try String(contentsOfFile: "input13.txt")
print("🌟 :", 🗓1️⃣3️⃣(input: input, part2: false))
print("🌟 :", 🗓1️⃣3️⃣(input: input, part2: true))
