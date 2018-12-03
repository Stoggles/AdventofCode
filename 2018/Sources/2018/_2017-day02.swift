import Foundation

func 🗓0️⃣2️⃣(input: String, part2: Bool) -> Int {
    var checksum = 0

    for line in input.split(separator: "\n") {
        let valueArray = line.split(separator: "\t").compactMap{Int($0)}

        if (part2) {
	    for (index1, value1) in valueArray.enumerated() {
		for (index2, value2) in valueArray.enumerated() {
		    if (index1 == index2) {
		        continue
		    }
                    if (value1 % value2 == 0) {
                        checksum += value1 / value2
                    }
                }
            }
        } else {
            var min = Int.max
            var max = Int.min

            for value in valueArray {
                if value > max {
                    max = value
                }
                if value < min {
                    min = value
                }
            }
            checksum += max - min
        }
    }
    
    return checksum
}

let test01 = "5\t1\t9\t5\n7\t5\t3\n2\t4\t6\t8"
let test02 = "5\t9\t2\t8\n9\t4\t7\t3\n3\t8\t6\t5"

assert(🗓0️⃣2️⃣(input: test01, part2: false) == 18)
assert(🗓0️⃣2️⃣(input: test02, part2: true) == 9)

let input = try String(contentsOfFile: "2017-input02.txt")
print("🌟 :", 🗓0️⃣2️⃣(input: input, part2: false))
print("🌟 :", 🗓0️⃣2️⃣(input: input, part2: true))
