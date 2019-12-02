use std::convert::TryInto;


fn parse(input: &str) -> Option<Vec<i32>> {
    input.trim().split(",").map(|s| s.parse().ok()).collect()
}

fn prime_memory(mut memory: Vec<i32>, verb: i32, noun: i32) -> Vec<i32> {
    memory[1] = verb;
    memory[2] = noun;

    return memory;
}

fn part1(mut memory: Vec<i32>) -> i32 {
    let mut instr_pointer = 0;

    while memory[instr_pointer] != 99 {
        let param_a: usize = memory[instr_pointer + 1].try_into().unwrap();
        let param_b: usize = memory[instr_pointer + 2].try_into().unwrap();
        let param_c: usize = memory[instr_pointer + 3].try_into().unwrap();
        if memory[instr_pointer] == 1 {
            memory[param_c] = memory[param_a] + memory[param_b];
        } else if memory[instr_pointer] == 2 {
            memory[param_c] = memory[param_a] * memory[param_b];
        }
        instr_pointer += 4;
    }

    return memory[0];
}

fn part2(memory: Vec<i32>, target: i32) -> i32 {
    for noun in 0..99 {
        for verb in 0..99 {
            if part1(prime_memory(memory.clone(), noun, verb)) == target {
                return noun * 100 + verb
            }
        }
    }

    panic!("Failed to find answer")
}

fn main() {
    let test_1 = parse("1,9,10,3,2,3,11,0,99,30,40,50")
        .expect("Failed parsing test input");
    assert_eq!(part1(test_1), 3500);

    let input = std::fs::read_to_string("input02.txt")
        .expect("Failed reading file");
    let memory = parse(&input)
        .expect("Failed parsing input");

    println!("⭐️: {}", part1(prime_memory(memory.clone(), 12, 2)));
    println!("⭐️: {}", part2(memory.clone(), 19690720));
}
