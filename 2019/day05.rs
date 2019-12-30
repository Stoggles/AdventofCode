fn parse(input: &str) -> Vec<i32> {
    return input.trim().split(",").map(|s| s.parse().unwrap()).collect();
}

fn execute(mut memory: Vec<i32>, mut input: Vec<i32>) {
    let mut instr_pointer: usize = 0;

    loop {
        let opcode = memory[instr_pointer] % 100;
        let mode_a = memory[instr_pointer] / 100 % 10;
        let mode_b = memory[instr_pointer] / 1000 % 10;
        let mode_c = memory[instr_pointer] / 10000 % 10;

        let step = match opcode {
            1 => { // add
                let param_a: usize;
                let param_b: usize;
                let param_c: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }
                if mode_b == 0 { param_b = memory[instr_pointer + 2] as usize; } else { param_b = instr_pointer + 2; }
                if mode_c == 0 { param_c = memory[instr_pointer + 3] as usize; } else { param_c = instr_pointer + 3; }

                memory[param_c] = memory[param_a] + memory[param_b];

                4
            },
            2 => { // mul
                let param_a: usize;
                let param_b: usize;
                let param_c: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }
                if mode_b == 0 { param_b = memory[instr_pointer + 2] as usize; } else { param_b = instr_pointer + 2; }
                if mode_c == 0 { param_c = memory[instr_pointer + 3] as usize; } else { param_c = instr_pointer + 3; }

                memory[param_c] = memory[param_a] * memory[param_b];

                4
            },
            3 => { // store
                let param_a: usize = memory[instr_pointer + 1] as usize;

                memory[param_a] = input.remove(0);

                2
            },
            4 => { // print
                let param_a: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }

                println!("{}", memory[param_a]);

                2
            },
            5 => { // jmp if true
                let param_a: usize;
                let param_b: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }
                if mode_b == 0 { param_b = memory[instr_pointer + 2] as usize; } else { param_b = instr_pointer + 2; }

                if memory[param_a] != 0 {
                    instr_pointer = memory[param_b] as usize;
                    0
                } else {
                    3
                }
            },
            6 => { // jmp if false
                let param_a: usize;
                let param_b: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }
                if mode_b == 0 { param_b = memory[instr_pointer + 2] as usize; } else { param_b = instr_pointer + 2; }

                if memory[param_a] == 0 {
                    instr_pointer = memory[param_b] as usize;
                    0
                } else {
                    3
                }
            },
            7 => { // less than
                let param_a: usize;
                let param_b: usize;
                let param_c: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }
                if mode_b == 0 { param_b = memory[instr_pointer + 2] as usize; } else { param_b = instr_pointer + 2; }
                if mode_c == 0 { param_c = memory[instr_pointer + 3] as usize; } else { param_c = instr_pointer + 3; }

                memory[param_c] = (memory[param_a] < memory[param_b]) as i32;

                4
            },
            8 => { // equals
                let param_a: usize;
                let param_b: usize;
                let param_c: usize;
                if mode_a == 0 { param_a = memory[instr_pointer + 1] as usize; } else { param_a = instr_pointer + 1; }
                if mode_b == 0 { param_b = memory[instr_pointer + 2] as usize; } else { param_b = instr_pointer + 2; }
                if mode_c == 0 { param_c = memory[instr_pointer + 3] as usize; } else { param_c = instr_pointer + 3; }

                memory[param_c] = (memory[param_a] == memory[param_b]) as i32;

                4
            },
            99 => { break }, // terminate
            _ => {
                panic!("unrecognised opcode {}", opcode);
            },
        };

        instr_pointer += step
    }

}

fn main() {
    // let test_1 = parse("3,0,4,0,99");
    // let test_2 = parse("1002,4,3,4,33");
    // let test_3 = parse("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99");
    // execute(test_1);
    // execute(test_2);
    // execute(test_3);

    let input = std::fs::read_to_string("input05.txt")
        .expect("Failed reading file");
    let memory = parse(&input);

    println!("⭐️: "); execute(memory.clone(), vec![1]);
    println!("⭐️: "); execute(memory.clone(), vec![5]);
}
