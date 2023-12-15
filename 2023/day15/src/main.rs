use std::collections::HashMap;


fn parse(input: &str) -> Vec<&str> {
    return input.trim().split(",").collect();
}

fn part_1(input: &str) -> u32 {
    let instructions: Vec<&str> = parse(input);

    return instructions.iter().map(|s| hash(s) as u32).sum()
}

fn part_2(input: &str) -> u32 {
    let instructions: Vec<&str> = parse(input);

    let mut map: HashMap<u8, Vec<(&str, u8)>> = HashMap::new();

    'outer: for instruction in instructions {
        let command: (&str, &str) = instruction.split_once(|c: char| c == '=' || c == '-').unwrap();
        let box_id: u8 = hash(command.0);
        if command.1.is_empty() {
            match map.get_mut(&box_id) {
                Some(b) => {
                    b.retain(|lens: &(&str, u8)| lens.0 != command.0);
                },
                None => {},
            }
        } else {
            let focal_length: u8 = command.1.parse::<u8>().unwrap();
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
        return (0..v.len()).map(|i: usize| (k + 1) as u32 * (i + 1) as u32 * v[i].1 as u32)
                           .sum::<u32>();
    }).sum::<u32>();
}

fn hash(input: &str) -> u8 {
    return input.bytes().fold(0, |a: u8, c: u8| a.wrapping_add(c).wrapping_mul(17));
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
