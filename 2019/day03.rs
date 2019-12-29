use std::cmp;
use std::collections::HashMap;


fn parse_instructions(input: &str) -> Vec<Vec<(&str, i32)>> {
    let mut instructions = Vec::new();

    for wire in input.lines() {
        let mut wire_instructions: Vec<(&str, i32)> = Vec::new();

        for instruction in wire.split(",") {
            let (direction, distance_str) = instruction.split_at(1);

            wire_instructions.push((direction, distance_str.parse().unwrap()));
        }

        instructions.push(wire_instructions);
    }

    return instructions;
}

fn populate_grid(instructions: &Vec<Vec<(&str, i32)>>) -> HashMap<(i32, i32), i32> {
    let mut grid: HashMap<(i32, i32), i32> = HashMap::new();

    let mut wire_count = 0;

    for wire in instructions {
        let mut x = 0;
        let mut y = 0;

        wire_count += 1;

        for instruction in wire {
            let mut distance = instruction.1;

            while distance > 0 {
                match instruction.0 {
                    "U" => y += 1,
                    "D" => y -= 1,
                    "L" => x -= 1,
                    "R" => x += 1,
                    _ => {},
                }

                distance -= 1;

                *grid.entry((x ,y)).or_insert(0) += wire_count;
            }
        }
    }

    return grid;
}

fn steps_to_point(instructions: &Vec<Vec<(&str, i32)>>, coords: (i32, i32)) -> i32 {
    let mut total_steps = 0;

    'outer: for wire in instructions {
        let mut x = 0;
        let mut y = 0;

        let mut steps = 0;

        for instruction in wire {
            let mut distance = instruction.1;

            while distance > 0 {
                match instruction.0 {
                    "U" => y += 1,
                    "D" => y -= 1,
                    "L" => x -= 1,
                    "R" => x += 1,
                    _ => {},
                }

                distance -= 1;
                steps += 1;

                if x == coords.0 && y == coords.1 {
                    total_steps += steps;
                    continue 'outer;
                }
            }
        }
    }

    return total_steps;
}

fn part1(input: &str) -> i32 {
    let instructions = parse_instructions(&input);
    let grid = populate_grid(&instructions);

    let mut distance = i32::max_value();

    for (coords, value) in &grid {
        if *value == 3 {
            distance = cmp::min(coords.0.abs() + coords.1.abs(), distance);
        }
    }

    return distance;
}

fn part2(input: &str) -> i32 {
    let instructions = parse_instructions(&input);
    let grid = populate_grid(&instructions);

    let mut distance = i32::max_value();

    for (coords, value) in &grid {
        if *value == 3 {
            distance = cmp::min(steps_to_point(&instructions, *coords), distance);
        }
    }

    return distance;
}

fn main() {
    let test_1 = "R8,U5,L5,D3\nU7,R6,D4,L4";
    let test_2 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83";
    let test_3 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7";

    assert_eq!(part1(test_1), 6);
    assert_eq!(part1(test_2), 159);
    assert_eq!(part1(test_3), 135);

    assert_eq!(part2(test_1), 30);
    assert_eq!(part2(test_2), 610);
    assert_eq!(part2(test_3), 410);

    let input = std::fs::read_to_string("input03.txt")
        .expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
