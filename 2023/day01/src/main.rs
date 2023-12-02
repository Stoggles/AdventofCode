use std::collections::HashMap;

fn part1(input: &str) -> u32 {
    let mut total: u32 = 0;

    for line in input.lines().map(|s: &str| s.trim()) {
        if line.is_empty() {
            continue;
        }

        let mut digits: Vec<char> = Vec::new();

        for char in line.chars() {
            if char.is_ascii_digit() {
                digits.push(char);
            }
        }

        total += digits[0].to_digit(10).unwrap() * 10 + digits[digits.len()-1].to_digit(10).unwrap();
    }

    return total;
}

fn part2(input: &str) -> u32 {
    let text_map: HashMap<&str, char> = HashMap::from([("one", '1'), ("two", '2'), ("three", '3'), ("four", '4'), ("five", '5'), ("six", '6'), ("seven", '7'), ("eight", '8'), ("nine", '9')]);

    let mut total: u32 = 0;

    for line in input.lines().map(|s: &str| s.trim()) {
        if line.is_empty() {
            continue;
        }

        let mut digits: Vec<char> = Vec::new();

        'outer: for x in 0..line.len() {
            if line.chars().nth(x).unwrap().is_ascii_digit() {
                digits.push(line.chars().nth(x).unwrap());
                continue;
            }
            for y in x+1..line.len()+1 {
                if text_map.contains_key(&&line[x..y]) {
                    digits.push(*text_map.get(&&line[x..y]).unwrap());
                    continue 'outer;
                }
            }
        }

        total += digits[0].to_digit(10).unwrap() * 10 + digits[digits.len()-1].to_digit(10).unwrap();
    }

    return total;
}

fn main() {
    let test_part1: &str = "1abc2\n
                            pqr3stu8vwx\n
                            a1b2c3d4e5f\n
                            treb7uchet\n";

    let test_part2: &str = "two1nine\n
                            eightwothree\n
                            abcone2threexyz\n
                            xtwone3four\n
                            4nineeightseven2\n
                            zoneight234\n
                            7pqrstsixteen\n";

    assert_eq!(part1(test_part1), 142);

    assert_eq!(part2(test_part2), 281);

    let input: String = std::fs::read_to_string("day01/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
