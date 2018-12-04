import Foundation

struct LogEntry: Hashable {
    var timestamp: Date
    var event: String
}

extension Date {
    var minute: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return Int(dateFormatter.string(from: self))!
    }
}

func 🗓0️⃣4️⃣(input: String, part2: Bool) -> Int {
    let stringArray = input.split(separator: "\n").compactMap{String($0)}
    var logEntryArray = [LogEntry]()

    let pattern = "^\\[(.*)\\] (.*)$"
    let regex = try! NSRegularExpression(pattern: pattern)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    for string in stringArray {
        if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            logEntryArray.append(
                LogEntry(
                    timestamp: dateFormatter.date(from: String(string[Range(match.range(at: 1), in: string)!]))!,
                    event: String(string[Range(match.range(at: 2), in: string)!])
                )
            )
        }
    }

    logEntryArray.sort(by: {$0.timestamp < $1.timestamp})

    let guardNumberRegex = try! NSRegularExpression(pattern: "^Guard #(\\d+) begins shift$")
    let startRegex = try! NSRegularExpression(pattern: "^falls asleep$")
    let endRegex = try! NSRegularExpression(pattern: "^wakes up$")

    var guardMap = [Int: [Int: Int]]()
    var guardNumber = 0
    var startMinute = 0
    var endMinute = 0

    for i in 0..<logEntryArray.count {
        let timestamp = logEntryArray[i].timestamp
        let event = logEntryArray[i].event

        if let match = guardNumberRegex.firstMatch(in: event,
                                                    options: [],
                                                    range: NSRange(location: 0,
                                                                   length: event.count)) {
            guardNumber = Int(event[Range(match.range(at: 1), in: event)!])!
            continue
        }

        if startRegex.numberOfMatches(in: event, options: [], range: NSRange(location: 0, length: event.count)) > 0 {
            startMinute = timestamp.minute
            continue
        }

        if endRegex.numberOfMatches(in: event, options: [], range: NSRange(location: 0, length: event.count)) > 0 {
            endMinute = timestamp.minute
            var guardSleepMap = guardMap[guardNumber] ?? [Int: Int]()
            for i in startMinute..<endMinute {
                guardSleepMap[i] = (guardSleepMap[i] ?? 0) + 1
            }
            guardMap[guardNumber] = guardSleepMap
            continue
        }
    }

    if part2 {
        let sleepestGuard = guardMap.max{a, b in a.value.values.max{a, b in a < b}! < b.value.values.max{a, b in a < b}!}!.key
        return guardMap[sleepestGuard]!.max{a, b in a.value < b.value}!.key * sleepestGuard
    } else {
        let sleepestGuard = guardMap.max{a, b in a.value.compactMap{$1}.reduce(0, +) < b.value.compactMap{$1}.reduce(0, +)}!.key
        return guardMap[sleepestGuard]!.max{a, b in a.value < b.value}!.key * sleepestGuard
    }
}

let testData = "[1518-11-01 00:00] Guard #10 begins shift\n[1518-11-01 00:05] falls asleep\n[1518-11-01 00:25] wakes up\n[1518-11-01 00:30] falls asleep\n[1518-11-01 00:55] wakes up\n[1518-11-01 23:58] Guard #99 begins shift\n[1518-11-02 00:40] falls asleep\n[1518-11-02 00:50] wakes up\n[1518-11-03 00:05] Guard #10 begins shift\n[1518-11-03 00:24] falls asleep\n[1518-11-03 00:29] wakes up\n[1518-11-04 00:02] Guard #99 begins shift\n[1518-11-04 00:36] falls asleep\n[1518-11-04 00:46] wakes up\n[1518-11-05 00:03] Guard #99 begins shift\n[1518-11-05 00:45] falls asleep\n[1518-11-05 00:55] wakes up"
assert(🗓0️⃣4️⃣(input: testData, part2: false) == 240)
assert(🗓0️⃣4️⃣(input: testData, part2: true) == 4455)

let input = try String(contentsOfFile: "input04.txt")
print("🌟 :", 🗓0️⃣4️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣4️⃣(input: input, part2: true))
