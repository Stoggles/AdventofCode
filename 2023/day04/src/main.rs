use std::collections::{BTreeMap};


fn parse(input: &str) -> BTreeMap<u32, (Vec<u32>, Vec<u32>)> {
    return input.lines()
                .filter(|line: &&str| !line.is_empty())
                .map(|line: &str| {
                    let game_number_segments: (&str, &str) = line.trim().split_once(":").unwrap();
                    let game_number: u32 = game_number_segments.0.split_ascii_whitespace().last().unwrap().parse::<u32>().unwrap();

                    let game_definition_segments: (&str, &str) = game_number_segments.1.split_once("|").unwrap();

                    let winning_numbers = game_definition_segments.0.split_ascii_whitespace();
                    let card_numbers = game_definition_segments.1.split_ascii_whitespace();

                    return(game_number, (winning_numbers.map(|s: &str| s.parse::<u32>().unwrap()).collect(), card_numbers.map(|s: &str| s.parse::<u32>().unwrap()).collect()));
                }).collect();
}

fn part1(input: &str) -> u32 {
    let game_map: BTreeMap<u32, (Vec<u32>, Vec<u32>)> = parse(input);

    let mut score: u32 = 0;

    game_map.into_values()
            .for_each(|game_definition: (Vec<u32>, Vec<u32>)| {
                let matches: u32 = play_card(&game_definition);
                if matches >= 1 {
                    score += 2_u32.pow(matches - 1);
                }
            });

    return score;
}

fn part2(input: &str) -> u32 {
    let game_map: BTreeMap<u32, (Vec<u32>, Vec<u32>)> = parse(input);

    let mut cards: Vec<(u32, u32)> = Vec::from(
        game_map.clone()
                .into_keys()
                .map(|digit: u32| return (digit, 1))
                .collect::<Vec<(u32, u32)>>());

    let mut card_count: u32 = 0;

    for index in 0..cards.len() {
        let target_card: (u32, u32) = cards.get(index).unwrap().clone();

        card_count += target_card.1;

        let score: u32 = play_card(game_map.get(&target_card.0).unwrap());

        for card_number in 1..=score as usize {
            cards.get_mut(index + card_number).unwrap().1 += target_card.1;
        }
    }

    return card_count;
}

fn play_card(game_definition: &(Vec<u32>, Vec<u32>)) -> u32 {
    let mut matches: u32 = 0;

    game_definition.0.iter().for_each(|matching_number: &u32| {
        if game_definition.1.contains(matching_number) {
            matches += 1;
        }
    });

    return matches;
}

fn main() {
    let test_input: &str = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\n
                            Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\n
                            Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\n
                            Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\n
                            Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\n
                            Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n";

    parse(test_input);

    assert_eq!(part1(test_input), 13);

    assert_eq!(part2(test_input), 30);

    let input: String = std::fs::read_to_string("day04/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
