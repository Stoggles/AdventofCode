use std::iter::zip;

fn parse_part1(input: &str) -> Vec<(u64, u64)> {
    let mut line_iter = input.lines()
                             .map(|line: &str| line.trim())
                             .filter(|line: &&str| !line.is_empty());

    let times: Vec<u64> = line_iter.next().unwrap()
                                   .strip_prefix("Time:").unwrap()
                                   .split_ascii_whitespace()
                                   .map(|s: &str| s.parse::<u64>().unwrap())
                                   .collect();
    let distances: Vec<u64> = line_iter.next().unwrap()
                                       .strip_prefix("Distance:").unwrap()
                                       .split_ascii_whitespace()
                                       .map(|s: &str| s.parse::<u64>().unwrap())
                                       .collect();

    return zip(times, distances).collect();
}

fn parse_part2(input: &str) -> (u64, u64) {
    let mut line_iter = input.lines()
                             .map(|line: &str| line.trim())
                             .filter(|line: &&str| !line.is_empty());

    let time: u64 = line_iter.next().unwrap()
                             .strip_prefix("Time:").unwrap()
                             .replace(" ", "")
                             .parse::<u64>().unwrap();
    let distance: u64 = line_iter.next().unwrap()
                                 .strip_prefix("Distance:").unwrap()
                                 .replace(" ", "")
                                 .parse::<u64>().unwrap();

    return (time, distance);
}

fn part1(input: &str) -> u64 {
    let races: Vec<(u64, u64)> = parse_part1(input);

    return races.iter().map(|race: &(u64, u64)| run_race(*race)).product();
}

fn part2(input: &str) -> u64 {
    let race: (u64, u64) = parse_part2(input);

    return run_race(race);
}

fn run_race(race: (u64, u64)) -> u64 {
    let mut possible_victories: u64 = 0;

    for time in 0..=race.0 {
        if (race.0 - time) * time > race.1 {
            possible_victories += 1;
        }
    }

    return possible_victories;
}

fn main() {
    let test_input: &str = "Time:      7  15   30\n
                            Distance:  9  40  200\n";

    assert_eq!(part1(test_input), 288);

    assert_eq!(part2(test_input), 71503);

    let input: String = std::fs::read_to_string("day06/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
