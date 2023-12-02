use std::collections::HashMap;

fn parse(input: &str) -> HashMap<u32, (u32, u32, u32)> {
    let mut game_map: HashMap<u32, (u32, u32, u32)> = HashMap::new();

    for line in input.lines().map(|s: &str| s.trim()) {
        if line.is_empty() {
            continue;
        }

        let mut segments = line.split(": ");

        let game_number = segments.next().unwrap().split(" ").last().unwrap().parse::<u32>().unwrap();

        let mut red = 0;
        let mut blue = 0;
        let mut green = 0;

        for game in segments.next().unwrap().split("; ") {
            for colour_segment in game.split(", ") {
                let mut digit_segments = colour_segment.split(" ");
                let digit = digit_segments.next().unwrap().parse::<u32>().unwrap();
                let colour = digit_segments.next().unwrap();
                match colour {
                    "red" => if digit > red {
                        red = digit;
                    },
                    "blue" => if digit > blue {
                        blue = digit;
                    },
                    "green" => if digit > green {
                        green = digit;
                    },
                    &_ => panic!(),
                }
            }
        }

        game_map.insert(game_number, (red, green, blue));
    }

    return game_map;
}

fn part1(input: &str, target_red: u32, target_blue: u32, target_green: u32) -> u32 {
    let game_map = parse(input);

    let mut total: u32 = 0;

    for entry in game_map.into_iter() {
        let digits = entry.1;
        if digits.0 <= target_red && digits.1 <= target_blue && digits.2 <= target_green {
            total += entry.0;
        }
    }

    return total;
}

fn part2(input: &str) -> u32 {
    let game_map = parse(input);

    let mut total: u32 = 0;

    for entry in game_map.into_iter() {
        total += entry.1.0 * entry.1.1 * entry.1.2;
    }

    return total;
}

fn main() {
    let test_input: &str = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n
                            Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\n
                            Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red\n
                            Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red\n
                            Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green\n";

    assert_eq!(part1(test_input, 12, 13, 14), 8);

    assert_eq!(part2(test_input), 2286);

    let input: String = std::fs::read_to_string("day02/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input, 12, 13, 14));
    println!("⭐️: {}", part2(&input));
}
