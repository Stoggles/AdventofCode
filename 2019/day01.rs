use std::cmp;


fn parse(input: &str) -> Option<Vec<i32>> {
    input.lines().map(|s| s.parse().ok()).collect()
}

fn part1(mass: i32) -> i32 {
    return ( mass / 3 ) - 2
}

fn part2(mut mass: i32) -> i32 {
    let mut total = 0;

    while mass > 0 {
        mass = cmp::max(( mass / 3 ) - 2, 0);
        total += mass;
    }

    return total;
}

fn main() {
    assert_eq!(part1(12), 2);
    assert_eq!(part1(14), 2);
    assert_eq!(part1(1969), 654);
    assert_eq!(part1(100756), 33583);

    assert_eq!(part2(14), 2);
    assert_eq!(part2(1969), 966);
    assert_eq!(part2(100756), 50346);

    let input = std::fs::read_to_string("input01.txt")
        .expect("Failed reading file");
    let masses = parse(&input)
        .expect("Failed parsing input");

    println!("⭐️: {}", masses.iter().map(|x| part1(*x)).sum::<i32>());
    println!("⭐️: {}", masses.iter().map(|x| part2(*x)).sum::<i32>());
}
