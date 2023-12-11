use core::panic;
use std::{collections::{HashMap, HashSet}, cmp};

fn parse(input: &str) -> Vec<Vec<char>> {
    return input.lines().filter(|line: &&str| !line.is_empty())
                .map(|line: &str| line.trim())
                .collect::<Vec<&str>>()
                .into_iter().map(|string: &str| string.chars().collect())
                .collect::<Vec<Vec<char>>>();
}

fn part1(input: &str) -> usize {
    let map: Vec<Vec<char>> = parse(input);

    let starting_location: (usize, usize) = find_starting_cell(&map);
    let starting_directions: Vec<(isize, isize)> = vec![(0, -1), (0, 1), (1, 0), (-1, 0)];
    let mut candidate_cells = Vec::new();
    for direction in starting_directions {
        if starting_location.0.checked_add_signed(direction.0).is_some() && starting_location.1.checked_add_signed(direction.1).is_some() {
            let dx: usize = starting_location.0.checked_add_signed(direction.0).unwrap();
            let dy: usize = starting_location.1.checked_add_signed(direction.1).unwrap();

            if find_cell_exits(map[dy][dx]).into_iter().any(|exit: (isize, isize)| {
                direction.0 + exit.0 == 0 && direction.1 + exit.1 == 0 }) {
                    candidate_cells.push((dx, dy));
            }
        }
    }

    let mut cell_distances: HashMap<(usize, usize), usize> = HashMap::from([(starting_location, 0)]);
    for mut cell in candidate_cells {
        let mut visited_cells: HashSet<(usize, usize)> = HashSet::from([starting_location]);
        'inner: while !visited_cells.contains(&cell) {
            cell_distances.entry(cell)
                          .and_modify(|entry: &mut usize| *entry = cmp::min(visited_cells.len(), *entry) )
                          .or_insert(visited_cells.len());

            visited_cells.insert(cell);

            for exit in find_cell_exits(map[cell.1][cell.0]) {
                let new_x = cell.0.checked_add_signed(exit.0).unwrap();
                let new_y = cell.1.checked_add_signed(exit.1).unwrap();

                if !visited_cells.contains(&(new_x, new_y)) {
                    cell = (new_x, new_y);
                    continue 'inner;
                }
            }
        }
    }

    return cell_distances.into_values().max().unwrap();
}

fn part2(input: &str) -> u32 {
    let mut map: Vec<Vec<char>> = parse(input);

    let starting_location: (usize, usize) = find_starting_cell(&map);
    let starting_directions: Vec<(isize, isize)> = vec![(0, -1), (0, 1), (1, 0), (-1, 0)];
    let mut candidate_cells = Vec::new();
    let mut candidate_exits = Vec::new();
    for direction in starting_directions.clone() {
        if starting_location.0.checked_add_signed(direction.0).is_some() && starting_location.1.checked_add_signed(direction.1).is_some() {
            let dx: usize = starting_location.0.checked_add_signed(direction.0).unwrap();
            let dy: usize = starting_location.1.checked_add_signed(direction.1).unwrap();

            if find_cell_exits(map[dy][dx]).into_iter().any(|exit: (isize, isize)| {
                direction.0 + exit.0 == 0 && direction.1 + exit.1 == 0 }) {
                    candidate_cells.push((dx, dy));
                    candidate_exits.push(direction);
            }
        }
    }

    map[starting_location.1][starting_location.0] = find_pipe_from_exits(candidate_exits[0], candidate_exits[1]);

    let mut pipe_cells: HashSet<(usize, usize)> = HashSet::from([starting_location]);
    let mut cell: (usize, usize) = candidate_cells[0];
    'outer: while !pipe_cells.contains(&cell) {
        pipe_cells.insert(cell);

        for exit in find_cell_exits(map[cell.1][cell.0]) {
            let new_x = cell.0.checked_add_signed(exit.0).unwrap();
            let new_y = cell.1.checked_add_signed(exit.1).unwrap();

            if !pipe_cells.contains(&(new_x, new_y)) {
                cell = (new_x, new_y);
                continue 'outer;
            }
        }
    }

    let mut enclosed_cells: u32 = 0;
    for y in 0..map.len() {
        for x in 0..map[y].len() {
            if pipe_cells.contains(&(x, y)) {
                continue;
            }

            enclosed_cells += count_intersections((x,y), &map, &pipe_cells) % 2;
        }
    }

    return enclosed_cells;
}

fn find_starting_cell(map: &Vec<Vec<char>>) -> (usize, usize) {
    for y in 0 .. map.len() {
        for x in 0 .. map[y].len() {
            if map[y][x].eq(&'S') {
                return (x, y);
            }
        }
    }

    panic!();
}

fn find_cell_exits(cell: char) -> Vec<(isize, isize)> {
    match cell {
        '|' => { return vec![(0, -1), (0, 1)]},
        '-' => { return vec![(-1, 0), (1, 0)]},
        'L' => { return vec![(0, -1), (1, 0)]},
        'J' => { return vec![(0, -1), (-1, 0)]},
        '7' => { return vec![(-1, 0), (0, 1)]},
        'F' => { return vec![(1, 0),  (0, 1)]},
        '.' => { return vec![] }
        'S' => { return vec![] } // should we re-write S on the map? Probably
        _   => { panic!() },
    }
}

fn find_pipe_from_exits(a: (isize, isize), b: (isize, isize)) -> char {
    for candidate in Vec::from(['|', '-', 'L', 'J', '7', 'F']) {
        let exits = find_cell_exits(candidate);
        if exits.contains(&a) && exits.contains(&b) {
            return candidate;
        }
    }
    panic!();
}

fn count_intersections(cell: (usize, usize), map: &Vec<Vec<char>>, pipe_cells: &HashSet<(usize, usize)>) -> u32 {
    let y: usize = cell.1;

    let mut intersections: u32 = 0;
    let mut pipe: Vec<char> = Vec::new();
    for x in (0..=cell.0).rev() {
        if pipe_cells.contains(&(x, y)) {
            if map[y][x] == '|' {
                intersections += 1;
            } else {
                pipe.push(map[y][x]);

                if pipe.len() > 1 && !pipe[pipe.len()-1].eq(&'-') {
                    // check if the ends of the pipe turn in different directions
                    if !(pipe[pipe.len()-1] == 'F' && pipe[0] == '7' || pipe[pipe.len()-1] == 'L' && pipe[0] == 'J') {
                        intersections += 1;
                    }
                    pipe.clear();
                }
            }
        }
    }

    return intersections;
}

fn main() {
    let test_input_1: &str = "-L|F7\n
                              7S-7|\n
                              L|7||\n
                              -L-J|\n
                              L|-JF\n";

    let test_input_2: &str = "7-F7-\n
                              .FJ|7\n
                              SJLL7\n
                              |F--J\n
                              LJ.LJ\n";

    let test_input_3: &str = "...........\n
                              .S-------7.\n
                              .|F-----7|.\n
                              .||.....||.\n
                              .||.....||.\n
                              .|L-7.F-J|.\n
                              .|..|.|..|.\n
                              .L--J.L--J.\n
                              ...........\n";

    let test_input_4: &str = "..........\n
                              .S------7.\n
                              .|F----7|.\n
                              .||OOOO||.\n
                              .||OOOO||.\n
                              .|L-7F-J|.\n
                              .|II||II|.\n
                              .L--JL--J.\n
                              ..........\n";

    let test_input_5: &str = ".F----7F7F7F7F-7....\n
                              .|F--7||||||||FJ....\n
                              .||.FJ||||||||L7....\n
                              FJL7L7LJLJ||LJ.L-7..\n
                              L--J.L7...LJS7F-7L7.\n
                              ....F-J..F7FJ|L7L7L7\n
                              ....L7.F7||L7|.L7L7|\n
                              .....|FJLJ|FJ|F7|.LJ\n
                              ....FJL-7.||.||||...\n
                              ....L---J.LJ.LJLJ...\n";

    let test_input_6: &str = "FF7FSF7F7F7F7F7F---7\n
                              L|LJ||||||||||||F--J\n
                              FL-7LJLJ||||||LJL-77\n
                              F--JF--7||LJLJ7F7FJ-\n
                              L---JF-JLJ.||-FJLJJ7\n
                              |F|F-JF---7F7-L7L|7|\n
                              |FFJF7L7F-JF7|JL---7\n
                              7-L-JL7||F7|L7F-7F7|\n
                              L.L7LFJ|||||FJL7||LJ\n
                              L7JLJL-JLJLJL--JLJ.L\n";

    assert_eq!(part1(test_input_1), 4);
    assert_eq!(part1(test_input_2), 8);

    assert_eq!(part2(test_input_3), 4);
    assert_eq!(part2(test_input_4), 4);
    assert_eq!(part2(test_input_5), 8);
    assert_eq!(part2(test_input_6), 10);

    let input: String = std::fs::read_to_string("day10/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
