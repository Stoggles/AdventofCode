use std::collections::{HashMap, VecDeque};

fn parse(input: &str) -> Vec<&str> {
    return input.trim().split(",").collect();
}

fn part_1(input: &str) -> u32 {
    let instructions: Vec<&str> = parse(input);

    return instructions.iter().map(|s| hash(s)).sum()
}

fn part_2(input: &str) -> u32 {
    let instructions: Vec<&str> = parse(input);

    let mut map: HashMap<u32, Vec<(&str, u32)>> = HashMap::new();

    'outer: for instruction in instructions {
        let command: (&str, &str) = instruction.split_once(|c| c == '=' || c == '-').unwrap();
        let box_id: u32 = hash(command.0);
        if command.1.is_empty() {
            match map.get_mut(&box_id) {
                Some(b) => {
                    b.retain(|lens| lens.0 != command.0);
                },
                None => {},
            }
        } else {
            let focal_length: u32 = command.1.parse::<u32>().unwrap();
            match map.get_mut(&box_id) {
                Some(b) => {
                    for lens in b.iter_mut() {
                        if lens.0 == command.0 {
                            lens.1 = focal_length;
                            continue 'outer;
                        }
                    }
                    b.push((command.0, focal_length))
                },
                None => {
                    map.insert(box_id, Vec::from([(command.0, focal_length)]));
                },
            }
        }
    }

    return map.iter().map(|(k , v)| {
        return (0..v.len()).map(|i| (k + 1) * (i as u32 + 1) * v[i].1)
                           .sum::<u32>();
    }).sum::<u32>();
}

fn hash(input: &str) -> u32 {
    let mut accumulator: u32 = 0;

    input.chars().for_each(|c: char| {
        accumulator = ((accumulator + c as u32) * 17) % 256;
    });

    return accumulator;
}

fn main() {
    let test_input: &str = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7";

    assert_eq!(hash("HASH"), 52);
    assert_eq!(part_1(test_input), 1320);
    assert_eq!(part_2(test_input), 145);

    let input: String = std::fs::read_to_string("day15/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part_1(&input));
    println!("⭐️: {}", part_2(&input));
}
