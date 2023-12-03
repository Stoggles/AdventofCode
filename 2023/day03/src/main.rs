use std::cmp;
use std::collections::HashMap;


fn parse(input: &str) -> Vec<Vec<char>> {
    let map: Vec<Vec<char>> = input.lines().filter(|line: &&str| !line.is_empty())
                                   .map(|line: &str| line.trim())
                                   .collect::<Vec<&str>>()
                                   .into_iter().map(|string: &str| string.chars().collect())
                                   .collect::<Vec<Vec<char>>>();

    return map;
}

fn part1(input: &str) -> u32 {
    let map: Vec<Vec<char>> = parse(input);

    let mut digits_stack: String = String::new();
    let mut part_numbers: Vec<u32> = Vec::new();

    for x_coord in 0 .. map.len() {
        let mut is_part_number: bool = false;
        for y_coord in 0 .. map[x_coord].len() {
            if !map[x_coord][y_coord].is_ascii_digit() {
                if is_part_number {
                    is_part_number = false;
                    part_numbers.push(digits_stack.parse::<u32>().unwrap());
                }
                digits_stack.clear();
                continue;
            }

            'outer: for x_jitter in cmp::max(1, x_coord) - 1 .. cmp::min(map.len(), x_coord + 2) {
                'inter: for y_jitter in cmp::max(1, y_coord) - 1 .. cmp::min(map[x_coord].len(), y_coord + 2) {
                    if map[x_jitter][y_jitter] != '.' && map[x_jitter][y_jitter].is_ascii_punctuation() {
                        is_part_number = true;
                        break 'outer;
                    }
                }
            }

            digits_stack.push(map[x_coord][y_coord]);
        }

        if is_part_number {
            part_numbers.push(digits_stack.parse::<u32>().unwrap());
        }
        digits_stack.clear();
    }

    return part_numbers.iter().sum::<u32>();
}

fn part2(input: &str) -> u32 {
    let map: Vec<Vec<char>> = parse(input);

    let mut digits_stack: String = String::new();
    let mut gear_map: HashMap<(usize, usize), Vec<u32>> = HashMap::new();

    for x_coord in 0 .. map.len() {
        let mut is_part_number: bool = false;
        let mut gear_coords: (usize, usize) = (0, 0);
        for y_coord in 0 .. map[x_coord].len() {
            if !map[x_coord][y_coord].is_ascii_digit() {
                if is_part_number {
                    is_part_number = false;
                    if gear_map.contains_key(&gear_coords) {
                        gear_map.get_mut(&gear_coords).unwrap().push(digits_stack.parse::<u32>().unwrap());
                    } else {
                        gear_map.insert(gear_coords, vec![digits_stack.parse::<u32>().unwrap()]);
                    }
                }
                digits_stack.clear();
                continue;
            }

            'outer: for x_jitter in cmp::max(1, x_coord) - 1 .. cmp::min(map.len(), x_coord + 2) {
                'inter: for y_jitter in cmp::max(1, y_coord) - 1 .. cmp::min(map[x_coord].len(), y_coord + 2) {
                    if map[x_jitter][y_jitter] == '*' {
                        is_part_number = true;
                        gear_coords = (x_jitter, y_jitter);
                        break 'outer;
                    }
                }
            }

            digits_stack.push(map[x_coord][y_coord]);
        }

        if is_part_number {
            if gear_map.contains_key(&gear_coords) {
                gear_map.get_mut(&gear_coords).unwrap().push(digits_stack.parse::<u32>().unwrap());
            } else {
                gear_map.insert(gear_coords, vec![digits_stack.parse::<u32>().unwrap()]);
            }
        }
        digits_stack.clear();
    }

    return gear_map.into_values().filter(|vec: &Vec<u32>| vec.len() == 2).map(|vec: Vec<u32>| vec.iter().product::<u32>()).sum::<u32>();
}

fn main() {
    let test_input: &str = "467..114..\n
                            ...*......\n
                            ..35..633.\n
                            ......#...\n
                            617*......\n
                            .....+.58.\n
                            ..592.....\n
                            ......755.\n
                            ...$.*....\n
                            .664.598..\n";

    assert_eq!(part1(test_input), 4361);

    assert_eq!(part2(test_input), 467835);

    let input: String = std::fs::read_to_string("day03/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
