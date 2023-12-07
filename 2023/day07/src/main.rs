use core::panic;
use std::{iter::zip, collections::HashSet, cmp::{Ordering, self}};

fn parse(input: &str) -> Vec<(&str, u32)> {
    return input.lines()
                .filter(|line: &&str| !line.is_empty())
                .map(|line: &str| {
                    let mut iter = line.trim().split_ascii_whitespace();
                    return (iter.next().unwrap(), iter.next().unwrap().parse::<u32>().unwrap());
                 })
                .collect();
}

fn score_card(card: char, part2: bool) -> u32 {
    match card {
        'A' => { return 14 },
        'K' => { return 13 },
        'Q' => { return 12 },
        'J' => { if part2 {
            return 1;
        } else {
            return 11;
        }},
        'T' => { return 10 },
        _ => { return card.to_digit(10).unwrap() },
    }
}

fn score_hand(hand: &str, part2: bool) -> u32 {
    let card_set: HashSet<char> = HashSet::from_iter(hand.chars());

    let unique_cards: usize ;
    if part2 && hand.contains('J') {
        unique_cards = cmp::max(1, card_set.len() - 1); // allow for 5 joker hands
    } else {
        unique_cards = card_set.len();
    }

    match unique_cards {
        1 => { return 7 },      // five of a kind
        2 => {
            for card in card_set.iter() {
                if hand.chars().filter(|c: &char| { c == card || part2 && c == &'J' }).count() == 4 {
                   return 6;    // four of a kind
                }
            }
            return 5;           // full house
        },
        3 => {
            for card in card_set.iter() {
                if hand.chars().filter(|c: &char| { c == card || part2 && c == &'J' }).count() == 3 {
                    return 4;   // three of a kind
                }
            }
            return 3;           // two pair
        },
        4 => { return 2 },      // one pair
        5 => { return 1 },      // high card
        _ => { panic!() },
    };
}

fn score_hands(mut hands: Vec<(&str, u32)>, part2: bool) -> u32 {
    hands.sort_by(|h1: &(&str, u32), h2: &(&str, u32)| {
        let hand_score_1: u32 = score_hand(h1.0, part2);
        let hand_score_2: u32 = score_hand(h2.0, part2);

        if hand_score_1 < hand_score_2 {
            return Ordering::Less;
        } else if hand_score_1 > hand_score_2 {
            return Ordering::Greater;
        } else {
            for (c1, c2) in zip(h1.0.chars(), h2.0.chars()) {
                let card_score_1: u32 = score_card(c1, part2);
                let card_score_2: u32 = score_card(c2, part2);

                if card_score_1 < card_score_2 {
                    return Ordering::Less;
                } else if card_score_1 > card_score_2 {
                    return Ordering::Greater;
                }
            }
            return Ordering::Equal;
        }
    });

    let mut rank: u32 = 0;
    return hands.iter().map(|hand: &(&str, u32)| { rank += 1; return rank * hand.1}).sum();
}

fn part1(input: &str) -> u32 {
    let hands: Vec<(&str, u32)> = parse(input);

    return score_hands(hands, false);

}

fn part2(input: &str) -> u32 {
    let hands: Vec<(&str, u32)> = parse(input);

    return score_hands(hands, true);
}

fn main() {
    let test_input: &str = "32T3K 765\n
                            T55J5 684\n
                            KK677 28\n
                            KTJJT 220\n
                            QQQJA 483\n";

    assert_eq!(part1(test_input), 6440);

    assert_eq!(part2(test_input), 5905);

    let input: String = std::fs::read_to_string("day07/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
