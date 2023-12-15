use std::cmp;

use combinations::Combinations;


fn parse(input: &str) -> (Vec<(usize, usize)>, Vec<usize>, Vec<usize>) {
    let map: Vec<Vec<char>> = input.lines().filter(|line: &&str| !line.is_empty())
                                   .map(|line: &str| line.trim())
                                   .collect::<Vec<&str>>()
                                   .into_iter().map(|string: &str| string.chars().collect())
                                   .collect::<Vec<Vec<char>>>();

    let mut galaxies: Vec<(usize, usize)> = Vec::new();

    for y in 0..map.len() {
        for x in 0..map[y].len() {
            if map[y][x] == '#' {
                galaxies.push((x, y));
            }
        }
    }

    let mut empty_rows: Vec<usize> = Vec::new();
    let mut empty_columns: Vec<usize> = Vec::new();

    'outer: for y in 0..map.len() {
        for x in 0..map[y].len() {
            if map[y][x] != '.' {
                continue 'outer;
            }
        }
        empty_rows.push(y);
    }

    'outer: for x in 0..map[0].len() {
        for y in 0..map.len() {
            if map[y][x] != '.' {
                continue 'outer;
            }
        }
        empty_columns.push(x);
    }

    return (galaxies, empty_rows, empty_columns);
}

fn sum_distances(input: &str, factor: u64) -> u64 {
    let image_data: (Vec<(usize, usize)>, Vec<usize>, Vec<usize>) = parse(input);

    let pairs: Vec<Vec<(usize, usize)>> = Combinations::new(image_data.0, 2).collect();

    let mut total_distance: u64 = 0;

    for pair in pairs {
        let s_1: (usize, usize) = pair[0];
        let s_2: (usize, usize) = pair[1];

        let mut x_distance: u64 = usize::abs_diff(s_1.0, s_2.0).try_into().unwrap();
        let mut y_distance: u64 = usize::abs_diff(s_1.1, s_2.1).try_into().unwrap();

        for x in cmp::min(s_1.0, s_2.0)..cmp::max(s_1.0, s_2.0) {
            if image_data.2.contains(&x) {
                x_distance += factor - 1;
            }
        }

        for y in cmp::min(s_1.1, s_2.1)..cmp::max(s_1.1, s_2.1) {
            if image_data.1.contains(&y) {
                y_distance += factor - 1;
            }
        }

        total_distance += x_distance + y_distance;
    }

    return total_distance;
}

fn main() {
    let test_input: &str = "...#......
                            .......#..
                            #.........
                            ..........
                            ......#...
                            .#........
                            .........#
                            ..........
                            .......#..
                            #...#.....\n";

    assert_eq!(sum_distances(test_input, 2), 374);
    assert_eq!(sum_distances(test_input, 10), 1030);
    assert_eq!(sum_distances(test_input, 100), 8410);

    let input: String = std::fs::read_to_string("day11/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", sum_distances(&input, 2));
    println!("⭐️: {}", sum_distances(&input, 1_000_000));
}
