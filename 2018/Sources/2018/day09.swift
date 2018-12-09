import Foundation

public final class LinkedList<T> {

    public class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        var previous: LinkedListNode?

        public init(value: T) {
            self.value = value
        }

        public func forward(steps: Int) -> LinkedListNode {
            var node = self
            for _ in 0..<steps {
                node = node.next!
            }

            return node
        }

        public func backward(steps: Int) -> LinkedListNode {
            var node = self
            for _ in 0..<steps {
                node = node.previous!
            }

            return node
        }
    }

    public init() {}

    public typealias Node = LinkedListNode<T>

    private(set) var head: Node?

    public var last: Node? {
        guard var node = head else {
            return nil
        }

        while let next = node.next {
            node = next
        }
        return node
    }

    public func node(at index: Int) -> Node {
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node!.next
            }

            return node!
        }
    }

    public func append(_ value: T) {
        let newNode = Node(value: value)
        if let lastNode = last {
            newNode.previous = lastNode
            newNode.next = head!
            head!.previous = newNode
            lastNode.next = newNode
        } else {
            head = newNode
            head!.next = newNode
            head!.previous = newNode
        }
    }

    public func insert(_ value: T, at node: Node) -> Node {
        let newNode = Node(value: value)
        let prev = node.previous!
        let next = prev.next
        newNode.previous = prev
        newNode.next = next
        next?.previous = newNode
        prev.next = newNode

        return newNode
    }

    public func remove(at node: inout Node) {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev

        node.previous = nil
        node.next = nil

        node = next!
    }
}

func 🗓0️⃣9️⃣(input: String, part2: Bool) -> Int {
    let pattern = "^(\\d+) players; last marble is worth (\\d+) points$"
    let regex = try! NSRegularExpression(pattern: pattern)

    var player_count = 0
    var max_score = 0
    if let match = regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
        player_count = Int(input[Range(match.range(at: 1), in: input)!])!
        max_score = Int(input[Range(match.range(at: 2), in: input)!])!
    }

    if part2 {
        max_score *= 100
    }

    var scores = [Int: Int]()
    let circle = LinkedList<Int>()
    circle.append(0)
    var current_marble_pointer = circle.head!

    for i in 1..<max_score + 1 {
        if i % 23 == 0 {
            let current_player = i % player_count
            current_marble_pointer = current_marble_pointer.backward(steps: 7)
            scores[current_player] = (scores[current_player] ?? 0) + i + current_marble_pointer.value
            circle.remove(at: &current_marble_pointer)
        } else {
            current_marble_pointer = current_marble_pointer.forward(steps: 2)
            current_marble_pointer = circle.insert(i, at: current_marble_pointer)
        }
    }

    return scores.values.max()!
}

assert(🗓0️⃣9️⃣(input: "9 players; last marble is worth 25 points", part2: false) == 32)
assert(🗓0️⃣9️⃣(input: "10 players; last marble is worth 1618 points", part2: false) == 8317)
assert(🗓0️⃣9️⃣(input: "13 players; last marble is worth 7999 points", part2: false) == 146373)
assert(🗓0️⃣9️⃣(input: "17 players; last marble is worth 1104 points", part2: false) == 2764)
assert(🗓0️⃣9️⃣(input: "21 players; last marble is worth 6111 points", part2: false) == 54718)
assert(🗓0️⃣9️⃣(input: "30 players; last marble is worth 5807 points", part2: false) == 37305)

let input = try String(contentsOfFile: "input09.txt")
print("🌟 :", 🗓0️⃣9️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣9️⃣(input: input, part2: true))
