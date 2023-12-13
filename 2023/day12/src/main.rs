use std::collections::HashMap;

fn parse(input: &str) -> Vec<(Vec<char>, Vec<u32>)> {
    return input.lines().filter(|line: &&str| !line.is_empty())
                        .map(|line: &str| {
                            let elements: (&str, &str) = line.trim().split_once(" ").unwrap();
                            return (elements.0.chars().collect(), elements.1.split(',').map(|s| s.parse::<u32>().unwrap()).collect())
                        })
                        .collect();
}

fn total_combinations(input: &str, factor: usize) -> u64 {
    let records: Vec<(Vec<char>, Vec<u32>)> = parse(input);

    return records.into_iter().map(|mut record: (Vec<char>, Vec<u32>)| {
        let unmod_string = record.0.clone();
        let unmod_group = record.1.clone();
        for _ in 0 .. factor - 1 {
            record.0.push('?');
            record.0.extend(unmod_string.iter());
            record.1.extend(unmod_group.iter());
        }

        let mut cache: HashMap<String, u64> = HashMap::new();

        return count_combinations(record.0, record.1, 0, &mut cache);
    }).sum();
}

fn count_combinations(mut string: Vec<char>, mut groups: Vec<u32>, current_group_length: u32, cache: &mut HashMap<String, u64>) -> u64 {
    let key: String = format!("{:?}{:?}{}", string, groups, current_group_length);

    match cache.get(&key) {
        Some(v) => { return *v },
        None => {
            match string.pop() {
                Some(c) => {
                    match c {
                        '.' => {
                            match groups.last() {
                                Some(s) => {
                                    if *s == current_group_length {
                                        groups.pop();
                                    } else if current_group_length > 0 {
                                        return 0;
                                    } },
                                None => { },
                            }
                            let r = count_combinations(string, groups, 0, cache);
                            cache.insert(key, r);
                            return r;
                        },
                        '#' => {
                            match groups.last() {
                                Some(s) => { if *s == current_group_length { return 0; } },
                                None => { return 0 },
                            }
                            let r = count_combinations(string, groups, current_group_length + 1, cache);
                            cache.insert(key, r);
                            return r;
                        }
                        '?' => {
                            match groups.last() {
                                Some(s) => {
                                    if *s == current_group_length { // must be '.'
                                        groups.pop();
                                        let r: u64 = count_combinations(string, groups, 0, cache);
                                        cache.insert(key, r);
                                        return r;
                                    } else if current_group_length > 0 && *s > current_group_length { // must be '#'
                                        let r: u64 = count_combinations(string, groups, current_group_length + 1, cache);
                                        cache.insert(key, r);
                                        return r;
                                    } else {
                                        let r_1: u64 = count_combinations(string.clone(), groups.clone(), 0, cache);
                                        let r_2: u64 = count_combinations(string.clone(), groups.clone(), current_group_length + 1, cache);

                                        cache.insert(key, r_1 + r_2);

                                        return r_1 + r_2;
                                    }
                                },
                                None => {
                                    let r: u64 = count_combinations(string, groups, 0, cache);
                                    cache.insert(key, r);
                                    return r;
                                },
                            }
                        },
                        _   => panic!()
                    }
                },
                None => {
                    match groups.last() {
                        Some(s) => {
                            if *s == current_group_length && groups.len() == 1 {
                                return 1;
                            } else {
                                return 0;
                            }
                        }
                        None => {
                            return 1
                        }
                    }
                },
            }
        }
    }
}

fn main() {
    let test_input: &str = "???.### 1,1,3\n
                            .??..??...?##. 1,1,3\n
                            ?#?#?#?#?#?#?#? 1,3,1,6\n
                            ????.#...#... 4,1,1\n
                            ????.######..#####. 1,6,5\n
                            ?###???????? 3,2,1\n";

    assert_eq!(total_combinations(test_input, 1), 21);
    assert_eq!(total_combinations(test_input, 5), 525152);

    let input: String = std::fs::read_to_string("day12/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", total_combinations(&input, 1));
    println!("⭐️: {}", total_combinations(&input, 5));
}
