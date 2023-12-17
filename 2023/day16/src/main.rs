use std::collections::{HashMap, HashSet};


fn parse(input: &str) -> HashMap<(i32, i32), char> {
    let mut map: HashMap<(i32, i32), char> = HashMap::new();

    let lines: Vec<&str> = input.lines().map(|line: &str| line.trim()).filter(|line: &&str| !line.is_empty()).collect();
    for y in 0..lines.len() {
        let elements: Vec<char> = lines[y].chars().collect();
        for x in 0..elements.len() {
            map.insert((x as i32, y as i32), elements[x]);
        }
    }

    return map;
}

fn part_1(input: &str) -> u32 {
    let map: HashMap<(i32, i32), char> = parse(input);

    let mut beams: Vec<((i32, i32), (i32, i32))> = vec![((0, 0), (1 , 0))];

    return count_energised_cells(&map, &mut beams);
}

fn part_2(input: &str) -> u32 {
    let map: HashMap<(i32, i32), char> = parse(input);

    let x_lim: i32 = map.keys().map(|coord: &(i32, i32)| coord.0).max().unwrap();
    let y_lim: i32 = map.keys().map(|coord: &(i32, i32)| coord.1).max().unwrap();

    let mut beams: Vec<((i32, i32), (i32, i32))> = Vec::new();
    let mut results: Vec<u32> = Vec::new();

    for x in 0..=x_lim {
        beams.push(((x, 0), (0 , 1)));
        results.push(count_energised_cells(&map, &mut beams));
        beams.push(((x, y_lim), (0, -1)));
        results.push(count_energised_cells(&map, &mut beams));
    }

    for y in 0..=y_lim {
        beams.push(((0, y), (1 , 0)));
        results.push(count_energised_cells(&map, &mut beams));
        beams.push(((x_lim, y), (-1 , 0)));
        results.push(count_energised_cells(&map, &mut beams));
    }

    return *results.iter().max().unwrap();
}

fn turn_left(pos_dir: ((i32, i32), (i32, i32))) -> ((i32, i32), (i32, i32)) {
    let dir: (i32, i32) = (pos_dir.1.1, pos_dir.1.0 * -1);
    let pos: (i32, i32) = (pos_dir.0.0 + dir.0, pos_dir.0.1 + dir.1);

    return (pos, dir);
}

fn turn_right(pos_dir: ((i32, i32), (i32, i32))) -> ((i32, i32), (i32, i32)) {
    let dir: (i32, i32) = (pos_dir.1.1 * - 1, pos_dir.1.0);
    let pos: (i32, i32) = (pos_dir.0.0 + dir.0, pos_dir.0.1 + dir.1);

    return (pos, dir);
}

fn count_energised_cells(map: &HashMap<(i32, i32), char>, beams: &mut Vec<((i32, i32), (i32, i32))>) -> u32 {
    let mut visited_cells: HashSet<((i32, i32), (i32, i32))> = HashSet::new();

    loop {
        match &mut beams.pop() {
            Some(pos_dir) => {
                match map.get(&pos_dir.0) {
                    Some(cell) => {
                        match visited_cells.get(&pos_dir) {
                            Some(_) => { continue; }, // in a loop
                            None => { visited_cells.insert(*pos_dir); }
                        }

                        match cell {
                            '.' => { beams.push(((pos_dir.0.0 + pos_dir.1.0, pos_dir.0.1 + pos_dir.1.1), pos_dir.1)); },
                            '/' => {
                                if pos_dir.1.1 != 0 {
                                    beams.push(turn_right(*pos_dir));
                                } else {
                                    beams.push(turn_left(*pos_dir));
                                }
                            },
                            '\\' => {
                                if pos_dir.1.0 != 0 {
                                    beams.push(turn_right(*pos_dir));
                                } else {
                                    beams.push(turn_left(*pos_dir));
                                }
                            },
                            '|' => {
                                if pos_dir.1.1 != 0 {
                                    beams.push(((pos_dir.0.0 + pos_dir.1.0, pos_dir.0.1 + pos_dir.1.1), pos_dir.1));
                                } else {
                                    beams.push(turn_left(*pos_dir));
                                    beams.push(turn_right(*pos_dir));
                                }
                            },
                            '-' => {
                                if pos_dir.1.0 != 0 {
                                    beams.push(((pos_dir.0.0 + pos_dir.1.0, pos_dir.0.1 + pos_dir.1.1), pos_dir.1));
                                } else {
                                    beams.push(turn_left(*pos_dir));
                                    beams.push(turn_right(*pos_dir));
                                }
                            },
                            _ => { panic!(); },
                        }
                    },
                    None => { continue; }, // off the map
                }
            },
            None => { break; }, // no beams remaining
        }
    }

    return visited_cells.iter().map(|pos_dir: &((i32, i32), (i32, i32))| pos_dir.0).collect::<HashSet<(i32, i32)>>().len() as u32;
}

fn main() {
    let test_input: &str = r".|...\....
                             |.-.\.....
                             .....|-...
                             ........|.
                             ..........
                             .........\
                             ..../.\\..
                             .-.-/..|..
                             .|....-|.\
                             ..//.|....";

    assert_eq!(part_1(test_input), 46);
    assert_eq!(part_2(test_input), 51);

    let input: String = std::fs::read_to_string("day16/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part_1(&input));
    println!("⭐️: {}", part_2(&input));
}
