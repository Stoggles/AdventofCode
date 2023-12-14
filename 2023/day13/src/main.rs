use std::iter::zip;

fn parse(input: &str) -> Vec<(Vec<String>, Vec<String>)> {
    let mut patterns: Vec<(Vec<String>, Vec<String>)> = Vec::new();

    let mut rows: Vec<String> = Vec::new();
    let mut columns: Vec<String> = Vec::new();

    for line in input.split('\n') {
        // println!("{}", line);
        if line.trim().is_empty() {
            // println!("rows length: {}", rows.len());
            for i in 0..rows[0].len() {
                columns.push(rows.iter().map(|r| r.chars().nth(i).unwrap()).collect::<String>());
            }
            patterns.push((rows.clone(), columns.clone()));
            rows.clear();
            columns.clear();
            continue;
        } else {
            rows.push(line.trim().to_owned());
        }
    }

    return patterns;
}

fn summarise_notes(input: &str, part2: bool) -> u32 {
    let patterns: Vec<(Vec<String>, Vec<String>)> = parse(input);

    let mut summary: usize = 0;

    for pattern in patterns {
        let row_index: (bool, usize) = find_mirror_index(pattern.0, part2);
        let column_index:(bool, usize) = find_mirror_index(pattern.1, part2);

        if row_index.0 {
            summary += row_index.1 * 100
        } else if column_index.0 {
            summary += column_index.1;
        }
    }

    return u32::try_from(summary).unwrap();
}

fn find_mirror_index(lines: Vec<String>, part2: bool) -> (bool, usize) {
    let allowed_differences: u32 = part2 as u32;

    'outer: for pair in (0..lines.len()).into_iter().collect::<Vec<usize>>().windows(2) {
        let mut total_differences: u32 = line_differences(&lines[pair[0]], &lines[pair[1]]);
        let mut index = 0;
        while total_differences <= allowed_differences {
            index += 1;

            if pair[1] + index >= lines.len() || pair[0].checked_sub(index).is_none() {
                if total_differences != allowed_differences {
                    continue 'outer;
                }
                return (true, pair[0] + 1);
            }

            total_differences += line_differences(&lines[pair[0] - index], &lines[pair[1] + index]);
        }
    }

    return (false, 0);
}

fn line_differences(line1: &str, line2: &str) -> u32 {
    return zip(line1.char_indices(), line2.char_indices())
        .map(|(c1, c2)| {
            if c1.1 == c2.1 {
                return 0
            } else {
                return 1
            }})
        .sum::<u32>();
}

fn main() {
    let test_input: &str = "#.##..##.
                            ..#.##.#.
                            ##......#
                            ##......#
                            ..#.##.#.
                            ..##..##.
                            #.#.##.#.

                            #...##..#
                            #....#..#
                            ..##..###
                            #####.##.
                            #####.##.
                            ..##..###
                            #....#..#\n";

    assert_eq!(summarise_notes(test_input, false), 405);
    assert_eq!(summarise_notes(test_input, true), 400);

    let input: String = std::fs::read_to_string("day13/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", summarise_notes(&input, false));
    println!("⭐️: {}", summarise_notes(&input, true));
}
