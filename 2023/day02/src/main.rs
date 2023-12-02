use std::collections::HashMap;

fn parse(input: &str) -> HashMap<u32, (u32, u32, u32)> {
    return input.lines()
                .filter(|line: &&str| !line.is_empty())
                .map(|line: &str| {
                    let mut segments = line.trim().split(": ");

                    let game_number: u32 = segments.next().unwrap().split(" ").last().unwrap().parse::<u32>().unwrap();

                    let mut game_values: (u32, u32, u32) = (0, 0, 0);

                    for game in segments.next().unwrap().split("; ") {
                        for colour_segment in game.split(", ") {
                            let mut digit_segments = colour_segment.split(" ");
                            let digit: u32 = digit_segments.next().unwrap().parse::<u32>().unwrap();
                            let colour: &str = digit_segments.next().unwrap();
                            match colour {
                                "red" => if digit > game_values.0 {
                                    game_values.0 = digit;
                                },
                                "blue" => if digit > game_values.1 {
                                    game_values.1 = digit;
                                },
                                "green" => if digit > game_values.2 {
                                    game_values.2 = digit;
                                },
                                &_ => panic!(),
                            }
                        }
                    }
                    return (game_number, game_values);
                })
                .collect::<HashMap<u32, (u32, u32, u32)>>();
}

fn part1(input: &str, target_red: u32, target_blue: u32, target_green: u32) -> u32 {
    return parse(input).into_iter()
                       .map(|entry: (u32, (u32, u32, u32))| {
                           if entry.1.0 <= target_red && entry.1.1 <= target_blue && entry.1.2 <= target_green {
                               return entry.0;
                           } else {
                               return 0;
                           }
                       })
                       .sum();
}

fn part2(input: &str) -> u32 {
    return parse(input).into_values().map(|tup: (u32, u32, u32)| tup.0 * tup.1 * tup.2).sum();
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
