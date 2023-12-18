use std::{collections::{HashMap, BinaryHeap}, cmp::Ordering};


#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
    cost: u32,
    position: (i32, i32),
    direction: (i32, i32),
}

impl Ord for State {
    fn cmp(&self, other: &State) -> Ordering {
        other.cost.cmp(&self.cost)
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &State) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn parse(input: &str) -> HashMap<(i32, i32), u32> {
    let mut map: HashMap<(i32, i32), u32> = HashMap::new();

    let lines: Vec<&str> = input.lines().map(|line: &str| line.trim()).filter(|line: &&str| !line.is_empty()).collect();
    for y in 0..lines.len() {
        let elements: Vec<char> = lines[y].chars().collect();
        for x in 0..elements.len() {
            map.insert((x as i32, y as i32), elements[x].to_digit(10).unwrap());
        }
    }

    return map;
}

fn find_route(input: &str, min_steps: i32, max_steps: i32) -> u32 {
    let map: HashMap<(i32, i32), u32> = parse(input);

    let x_target: i32 = map.keys().map(|position: &(i32, i32)| position.0).max().unwrap();
    let y_target: i32 = map.keys().map(|position: &(i32, i32)| position.1).max().unwrap();
    let target_position: (i32, i32) = (x_target, y_target);

    let mut heap: BinaryHeap<State> = BinaryHeap::new();
    let mut distance_map: HashMap<((i32, i32), (i32, i32), i32), u32> = HashMap::new();

    heap.push(State { cost: 0, position: (0,0), direction: (1, 0) });
    heap.push(State { cost: 0, position: (0,0), direction: (0, 1) });

    'outer: while let Some(State { mut cost, mut position, direction }) = heap.pop() {
        for steps in 1..=max_steps {
            position = (position.0 + direction.0, position.1 + direction.1);

            match map.get(&position) {
                Some(edge_cost) => {
                    cost += edge_cost;

                    if steps < min_steps {
                        continue;
                    }

                    match distance_map.get(&(position, direction, steps)) {
                        Some(previous_cost) => { if cost >= *previous_cost { continue 'outer } },
                        None => { },
                    }

                    distance_map.insert((position, direction, steps), cost);

                    if position == target_position { continue 'outer };

                    heap.push(State { cost: cost, position: position, direction: turn_left(direction) });
                    heap.push(State { cost: cost, position: position, direction: turn_right(direction) });
                },
                None => { continue 'outer; }
            }
        }
    }

    return *distance_map.iter().filter(|(k, _v)| k.0 == target_position).map(|(_k, v)| v).min().unwrap();
}

fn turn_left(direction: (i32, i32)) -> (i32, i32) { return (direction.1, direction.0 * -1); }

fn turn_right(direction: (i32, i32)) -> (i32, i32) { return (direction.1 * - 1, direction.0); }

fn main() {
    let test_input_1: &str = r"2413432311323
                               3215453535623
                               3255245654254
                               3446585845452
                               4546657867536
                               1438598798454
                               4457876987766
                               3637877979653
                               4654967986887
                               4564679986453
                               1224686865563
                               2546548887735
                               4322674655533";

    let test_input_2: &str = r"111111111111
                               999999999991
                               999999999991
                               999999999991
                               999999999991";

    assert_eq!(find_route(test_input_1, 1, 3), 102);
    assert_eq!(find_route(test_input_1, 4, 10), 94);
    assert_eq!(find_route(test_input_2, 4, 10), 71);

    let input: String = std::fs::read_to_string("day17/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", find_route(&input, 1, 3));
    println!("⭐️: {}", find_route(&input, 4, 10));
}
