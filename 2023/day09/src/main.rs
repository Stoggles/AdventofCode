fn parse(input: &str) -> Vec<Vec<i32>> {
    return input.lines()
                .filter(|line: &&str| !line.is_empty())
                .map(|line: &str| line.trim()
                                      .split_ascii_whitespace()
                                      .map(|s: &str| s.parse::<i32>().unwrap())
                                      .collect())
                .collect();
}

fn part1(input: &str) -> i32 {
    let dataset: Vec<Vec<i32>> = parse(input);

    return dataset.iter()
                  .map(|set: &Vec<i32>| extrapoldate(set.to_vec(), false))
                  .sum();
}

fn part2(input: &str) -> i32 {
    let dataset: Vec<Vec<i32>> = parse(input);

    return dataset.iter()
                  .map(|set: &Vec<i32>| extrapoldate(set.to_vec(), true))
                  .sum();
}

fn extrapoldate(dataset: Vec<i32>, backwards: bool) -> i32 {
    if dataset.iter().all(|v: &i32| v.eq(&dataset[0])) {
        return dataset[0];
    } else {
        let differences: Vec<i32> = dataset.windows(2)
                                           .map(|window: &[i32]| return window[1] - window[0])
                                           .collect();

        if backwards {
            return dataset[0] - extrapoldate(differences, backwards);
        } else {
            return dataset[dataset.len() - 1] + extrapoldate(differences, backwards);
        }
    }
}

fn main() {
    let test_input: &str = "0 3 6 9 12 15\n
                            1 3 6 10 15 21\n
                            10 13 16 21 30 45\n";

    assert_eq!(part1(test_input), 114);

    assert_eq!(part2(test_input), 2);

    let input: String = std::fs::read_to_string("day09/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
