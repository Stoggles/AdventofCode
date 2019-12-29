fn validate_password(input: i32, part2: bool) -> bool {
    let digit_vec = input.to_string()
        .chars()
        .map(|d| d.to_digit(10).unwrap())
        .collect::<Vec<_>>();

    let increment = (1..digit_vec.len()).all(|i| digit_vec[i - 1] <= digit_vec[i]);
    let double;

    if part2 {
        double = (1..digit_vec.len()).any(|i| match i {
            1 => (digit_vec[0] == digit_vec[1]) && (digit_vec[0] != digit_vec[2]),
            5 => (digit_vec[4] == digit_vec[5]) && (digit_vec[4] != digit_vec[3]),
            n => (digit_vec[n - 1] == digit_vec[n]) && (digit_vec[n + 1] != digit_vec[n]) && (digit_vec[n - 2] != digit_vec[n - 1]),
        })
    } else {
        double = (1..digit_vec.len()).any(|i| digit_vec[i - 1] == digit_vec[i])
    }

    return double && increment;
}

fn solve(a: i32, b: i32, part2: bool) -> i32 {
    let mut password_count = 0;

    for password in a..=b {
        if validate_password(password, part2) {
            password_count += 1;
        }
    }

    return password_count;
}

fn main() {
    let test_1 = 111111;
    let test_2 = 223450;
    let test_3 = 123789;

    assert_eq!(validate_password(test_1, false), true);
    assert_eq!(validate_password(test_2, false), false);
    assert_eq!(validate_password(test_3, false), false);

    let test_4 = 112233;
    let test_5 = 123444;
    let test_6 = 111122;

    assert_eq!(validate_password(test_4, true), true);
    assert_eq!(validate_password(test_5, true), false);
    assert_eq!(validate_password(test_6, true), true);

    println!("⭐️: {}", solve(273025, 767253, false));
    println!("⭐️: {}", solve(273025, 767253, true));
}
