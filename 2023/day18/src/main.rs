fn parse(input: &str) -> Vec<(char, i64, &str)> {
    return input.lines().filter(|line: &&str| !line.is_empty())
                        .map(|line: &str| {
                            let mut elements = line.trim().split_ascii_whitespace();
                            return (elements.next().unwrap().chars().nth(0).unwrap(), elements.next().unwrap().parse::<i64>().unwrap(), elements.next().unwrap());
                        })
                        .collect();
}

fn calculate_lagoon_volume(input: &str, part_2: bool) -> u64 {
    let instructions: Vec<(char, i64, &str)> = parse(input);

    let mut verticies: Vec<(i64, i64)> = Vec::new();
    let mut current_location: (i64, i64) = (0, 0);

    let mut boundry_cells: u64 = 0;

    for instruction in instructions {
        let distance: i64;
        if part_2 {
            distance = i64::from_str_radix(instruction.2.get(2..7).unwrap(), 16).unwrap();

            match instruction.2.as_bytes()[7] {
                b'0' => { current_location = (current_location.0 + distance, current_location.1); }
                b'1' => { current_location = (current_location.0, current_location.1 + distance); }
                b'2' => { current_location = (current_location.0 - distance, current_location.1); }
                b'3' => { current_location = (current_location.0, current_location.1 - distance); }
                _    => { panic!() },
            }
        } else {
            distance = instruction.1;

            match instruction.0 {
                'U' => { current_location = (current_location.0, current_location.1 - distance); }
                'D' => { current_location = (current_location.0, current_location.1 + distance); }
                'L' => { current_location = (current_location.0 - distance, current_location.1); }
                'R' => { current_location = (current_location.0 + distance, current_location.1); }
                _   => { panic!() },
            }

        }

        boundry_cells += distance as u64;
        verticies.push(current_location);
    }

    let shoelace_area: u64 = (verticies.windows(2).fold(0, |a: i64, coords: &[(i64, i64)]| { a + (coords[0].0 * coords[1].1) - (coords[0].1 * coords[1].0) }) / 2) as u64;
    let interior_cells: u64 = shoelace_area - (boundry_cells / 2) + 1;
    return interior_cells + boundry_cells;
}

fn main() {
    let test_input: &str = r"R 6 (#70c710)
                             D 5 (#0dc571)
                             L 2 (#5713f0)
                             D 2 (#d2c081)
                             R 2 (#59c680)
                             D 2 (#411b91)
                             L 5 (#8ceee2)
                             U 2 (#caa173)
                             L 1 (#1b58a2)
                             U 2 (#caa171)
                             R 2 (#7807d2)
                             U 3 (#a77fa3)
                             L 2 (#015232)
                             U 2 (#7a21e3)";

    assert_eq!(calculate_lagoon_volume(test_input, false), 62);
    assert_eq!(calculate_lagoon_volume(test_input, true), 952408144115);

    let input: String = std::fs::read_to_string("day18/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", calculate_lagoon_volume(&input, false));
    println!("⭐️: {}", calculate_lagoon_volume(&input, true));
}
