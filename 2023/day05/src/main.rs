use std::cmp;

fn parse(input: &str) -> (Vec<i64>, Vec<Vec<(i64, i64, i64)>>) {
    let mut seeds: Vec<i64> = Vec::new();
    let mut maps: Vec<Vec<(i64, i64, i64)>> = Vec::new();
    let mut map: Vec<(i64, i64, i64)> = Vec::new();

    input.lines()
            .map(|line: &str| line.trim())
            .filter(|line: &&str| !line.is_empty())
            .for_each(|line: &str| {
                if line.starts_with("seeds: ") {
                    line.replace("seeds: ", "").split(" ").for_each(|seed: &str| seeds.push(seed.parse::<i64>().unwrap()));
                    return;
                }

                if line.contains("map:") {
                    if !map.is_empty() {
                        maps.push(map.clone());
                    }

                    map.clear();
                    return;
                }

                let values: Vec<i64> = line.split(" ").into_iter().map(|v: &str| v.parse::<i64>().unwrap()).collect();
                map.push((values[0], values[1], values[2]));
            });

    maps.push(map.clone()); // don't forget the last map

    return (seeds, maps);
}

fn part1(input: &str) -> i64 {
    let almanac: (Vec<i64>, Vec<Vec<(i64, i64, i64)>>) = parse(input);

    let mut score: i64 = i64::MAX;

    almanac.0.iter().for_each(|seed: &i64| {
        let mut current_value: i64 = *seed;
        for range_map in &almanac.1 {
            // println!("map id: {}", map_id);
            for triple in range_map {
                // println!("triple: {:?}", triple);
                if current_value >= triple.1 && current_value <= triple.1 + triple.2 {
                    // println!("found value in map");
                    current_value = current_value + (triple.0 - triple.1);
                    // println!("current value: {}", current_value);
                    break;
                }
            };
        }

        score = cmp::min(current_value, score);
    });

    return score;
}

fn part2(input: &str) -> i64 {
    let almanac: (Vec<i64>, Vec<Vec<(i64, i64, i64)>>) = parse(input);

    let mut score: i64 = i64::MAX;

    almanac.0.chunks(2).for_each(|seed_range: &[i64]| {
        let mut input_ranges: Vec<(i64, i64)> = Vec::new();
        let mut output_ranges: Vec<(i64, i64)> = Vec::new();
        input_ranges.push((seed_range[0], seed_range[1]));

        for range_map in &almanac.1 {
            while !input_ranges.is_empty() {
                let range = input_ranges.pop().unwrap();

                let mut mapped: bool = false;

                for triple in range_map {
                    if range.0 >= triple.1 && range.0 + range.1 <= triple.1 + triple.2 {
                        output_ranges.push((triple.0 + range.0 - triple.1, range.1));
                        mapped = true;
                        break;
                    } else if range.0 < triple.1 && range.0 + range.1 > triple.1 {
                        output_ranges.push((triple.0, range.1 - (triple.1 - range.0)));
                        input_ranges.push((range.0, triple.1 - range.0));
                        mapped = true;
                        break;
                    }
                };

                if !mapped {
                    output_ranges.push(range);
                }
            }

            input_ranges = output_ranges.clone();
            output_ranges.clear();
        }

        for range in input_ranges {
            if score > range.0 {
                score = range.0;
            }
        }
    });

    return score;
}

fn main() {
    let test_input: &str = "seeds: 79 14 55 13\n
                            \n
                            seed-to-soil map:\n
                            50 98 2\n
                            52 50 48\n
                            \n
                            soil-to-fertilizer map:\n
                            0 15 37\n
                            37 52 2\n
                            39 0 15\n
                            \n
                            fertilizer-to-water map:\n
                            49 53 8\n
                            0 11 42\n
                            42 0 7\n
                            57 7 4\n
                            \n
                            water-to-light map:\n
                            88 18 7\n
                            18 25 70\n
                            \n
                            light-to-temperature map:\n
                            45 77 23\n
                            81 45 19\n
                            68 64 13\n
                            \n
                            temperature-to-humidity map:\n
                            0 69 1\n
                            1 0 69\n
                            \n
                            humidity-to-location map:\n
                            60 56 37\n
                            56 93 4\n";

    assert_eq!(part1(test_input), 35);

    assert_eq!(part2(test_input), 46);

    let input: String = std::fs::read_to_string("day05/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part1(&input));
    println!("⭐️: {}", part2(&input));
}
