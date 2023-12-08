use std::collections::HashMap;

use num_integer::Integer;


fn parse(input: &str) -> (Vec<char>, HashMap<&str, (&str, &str)>) {
    let mut iter = input.lines()
                        .map(|line: &str| line.trim())
                        .filter(|line: &&str| !line.is_empty());

    let instructions: Vec<char> = iter.next().unwrap().chars().collect();

    let map: HashMap<&str, (&str, &str)> = iter.map(|s: &str| {
        let mut segments = s.split(" = ");
        let key: &str = segments.next().unwrap();

        let mut destinations = segments.next().unwrap().split(", ");
        let value: (&str, &str) = (destinations.next().unwrap().trim_matches('('), destinations.next().unwrap().trim_matches(')'));

        return (key, value);
    }).collect();

    return (instructions, map);
}

fn part1(input: &str) -> u32 {
    let map: (Vec<char>, HashMap<&str, (&str, &str)>) = parse(input);

    let mut steps: u32 = 0;
    let mut current_location: &str = "AAA";

    for instruction in map.0.into_iter().cycle() {
        if current_location == "ZZZ" {
            break;
        }

        steps += 1;

        match instruction {
            'L' => { current_location = map.1.get(current_location).unwrap().0 },
            'R' => { current_location = map.1.get(current_location).unwrap().1 },
            _ => { panic!() },
        };
    }

    return steps;
}

fn part2(input: &str) -> u64 {
    let map: (Vec<char>, HashMap<&str, (&str, &str)>) = parse(input);

    let mut steps: Vec<u64> = Vec::new();
    let starting_locations: Vec<&str> = map.1.keys().filter(|s: &&&str| s.ends_with('A')).map(|s: &&str| *s).collect();

    'outer: for mut location in starting_locations {
        let mut step_count: u64 = 0;
        for instruction in map.0.iter().cycle() {
            if location.ends_with('Z') {
                steps.push(step_count);
                continue 'outer;
            }

            step_count += 1;

            match instruction {
                'L' => { location = map.1.get(location).unwrap().0 },
                'R' => { location = map.1.get(location).unwrap().1 },
                _ => { panic!() },
            };
        }
    }

    return steps.into_iter().fold(1, |a: u64, b: u64| a.lcm(&b));
}

fn main() {
    let test_input_part1: &str = "LLR\n
                                  \n
                                  AAA = (BBB, BBB)\n
                                  BBB = (AAA, ZZZ)\n
                                  ZZZ = (ZZZ, ZZZ)\n";

    let test_input_part2: &str = "LR\n
                                  \n
                                  11A = (11B, XXX)\n
                                  11B = (XXX, 11Z)\n
                                  11Z = (11B, XXX)\n
                                  22A = (22B, XXX)\n
                                  22B = (22C, 22C)\n
                                  22C = (22Z, 22Z)\n
                                  22Z = (22B, 22B)\n
                                  XXX = (XXX, XXX)\n";

    assert_eq!(part1(test_input_part1), 6);

    assert_eq!(part2(test_input_part2), 6);

    let input: String = std::fs::read_to_string("day08/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
