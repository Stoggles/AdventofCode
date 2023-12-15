use std::iter::zip;

use num::integer;


fn parse(input: &str) -> Vec<char> {
    return input.chars().filter(|c: &char| !(*c).is_whitespace()).collect();
}

fn part_1(input: &str) -> u32 {
    let map: Vec<char> = parse(input);
    let dimension: usize = integer::sqrt(map.len());

    let out_map: Vec<char> = shift_north(map, dimension);

    let total_load: usize = zip((1..=dimension).rev(), out_map.chunks(dimension))
        .map(|(load, row)| { row.iter().filter(|c: &&char| **c == 'O').count() * load })
        .sum();

    return total_load as u32;
}

fn part_2(input: &str, spins: usize) -> u32 {
    let map: Vec<char> = parse(input);
    let dimension: usize = integer::sqrt(map.len());

    let mut out_map: Vec<char> = map.clone();
    let mut loads: Vec<usize> = Vec::new();

    let loop_start: usize;

    loop {
        out_map = shift_north(out_map, dimension);
        out_map = shift_west(out_map, dimension);
        out_map = shift_south(out_map, dimension);
        out_map = shift_east(out_map, dimension);

        let total_load: usize = zip((1..=dimension).rev(), out_map.chunks(dimension))
            .map(|(load, row)| { row.iter().filter(|c: &&char| **c == 'O').count() * load })
            .sum();

        match get_cycle(&loads, total_load) {
            Some(i) => {
                loop_start = i;
                break;
            },
            None => {
                loads.push(total_load);
            },
        }
    }

    return loads[loop_start + (spins - loop_start - 1) % (loads.len() - loop_start)] as u32;
}

fn get_cycle(loads: &Vec<usize>, target_load: usize) -> Option<usize> {
    if loads.len() < 5 {
        return None;
    }

    for i in 0 .. loads.len() {
        if loads[i] == target_load {
            return Some(i);
        }
    }

    return None;
}

fn shift_north(map: Vec<char>, dimension: usize) -> Vec<char> {
    let mut out_map: Vec<char> = Vec::new();
    out_map.resize(map.len(), '.');

    for i in 0..dimension {
        let mut column: Vec<&char> = map.iter().skip(i).step_by(dimension).collect::<Vec<&char>>();

        for slice in column.split_mut(|c: &&char| **c == '#') {
            slice.sort();
            slice.reverse();
        };

        zip(column, (0..out_map.len()).skip(i).step_by(dimension)).for_each(|(char, index)| out_map[index] = *char);
    }

    return out_map;
}

fn shift_south(map: Vec<char>, dimension: usize) -> Vec<char> {
    let mut out_map: Vec<char> = Vec::new();
    out_map.resize(map.len(), '.');

    for i in 0..dimension {
        let mut column: Vec<&char> = map.iter().skip(i).step_by(dimension).collect::<Vec<&char>>();

        for slice in column.split_mut(|c: &&char| **c == '#') {
            slice.sort();
        };

        zip(column, (0..out_map.len()).skip(i).step_by(dimension)).for_each(|(char, index)| out_map[index] = *char);
    }

    return out_map;
}

fn shift_east(map: Vec<char>, dimension: usize) -> Vec<char> {
    let mut out_map: Vec<char> = Vec::new();
    out_map.resize(map.len(), '.');

    for i in 0..dimension {
        let mut row: Vec<&char> = map.iter().skip(i*dimension).take(dimension).collect::<Vec<&char>>();

        for slice in row.split_mut(|c: &&char| **c == '#') {
            slice.sort();
        };

        zip(row, 0..dimension).for_each(|(char, index)| out_map[i * dimension + index] = *char);
    }

    return out_map;
}

fn shift_west(map: Vec<char>, dimension: usize) -> Vec<char> {
    let mut out_map: Vec<char> = Vec::new();
    out_map.resize(map.len(), '.');

    for i in 0..dimension {
        let mut row: Vec<&char> = map.iter().skip(i*dimension).take(dimension).collect::<Vec<&char>>();

        for slice in row.split_mut(|c: &&char| **c == '#') {
            slice.sort();
            slice.reverse();
        };

        zip(row, 0..dimension).for_each(|(char, index)| out_map[i * dimension + index] = *char);
    }

    return out_map;
}

fn main() {
    let test_input: &str = "O....#....
                            O.OO#....#
                            .....##...
                            OO.#O....O
                            .O.....O#.
                            O.#..O.#.#
                            ..O..#O..O
                            .......O..
                            #....###..
                            #OO..#....\n";

    assert_eq!(part_1(test_input), 136);
    assert_eq!(part_2(test_input, 1_000_000_000), 64);

    let input: String = std::fs::read_to_string("day14/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part_1(&input));
    println!("⭐️: {}", part_2(&input, 1_000_000_000));
}
