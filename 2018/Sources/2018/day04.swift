import Foundation

struct LogEntry: Hashable {
    var timestamp: Date
    var event: String
}

func 🗓0️⃣4️⃣(input: String, part2: Bool) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{ String($0) }
    var logEntryArray = [LogEntry]()

    let pattern = "^\\[(.*)\\] (.*)$"
    let regex = try? NSRegularExpression(pattern: pattern)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    for string in stringArray {
        if let match = regex?.firstMatch(in: string,
                                         options: [],
                                         range: NSRange(location: 0,
                                                        length: string.utf16.count)) {
            logEntryArray.append(
                LogEntry(
                    timestamp: dateFormatter.date(from: String(string[Range(match.range(at: 1), in: string)!]))!,
                    event: String(string[Range(match.range(at: 2), in: string)!])
                )
            )
        }
    }

    for entry in logEntryArray.sorted(by: { $0.timestamp < $1.timestamp }) {
        print(entry)
    }

    return 240
}

let testData = "[1518-11-01 00:00] Guard #10 begins shift\n[1518-11-01 00:05] falls asleep\n[1518-11-01 00:25] wakes up\n[1518-11-01 00:30] falls asleep\n[1518-11-01 00:55] wakes up\n[1518-11-01 23:58] Guard #99 begins shift\n[1518-11-02 00:40] falls asleep\n[1518-11-02 00:50] wakes up\n[1518-11-03 00:05] Guard #10 begins shift\n[1518-11-03 00:24] falls asleep\n[1518-11-03 00:29] wakes up\n[1518-11-04 00:02] Guard #99 begins shift\n[1518-11-04 00:36] falls asleep\n[1518-11-04 00:46] wakes up\n[1518-11-05 00:03] Guard #99 begins shift\n[1518-11-05 00:45] falls asleep\n[1518-11-05 00:55] wakes up"
assert(🗓0️⃣4️⃣(input: testData, part2: false) == 240)
// assert(🗓0️⃣4️⃣(input: testData, part2: true) == 3)

let input = try String(contentsOfFile: "input04.txt")
// print("🌟 :", 🗓0️⃣4️⃣(input: input, part2: false))
// print("🌟 :", 🗓0️⃣4️⃣(input: input, part2: true))
