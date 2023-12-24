use std::collections::{HashMap, VecDeque};

use regex::Regex;


#[derive(Debug)]
struct Rule {
    variable: String,
    condition: String,
    expected_value: u32,
    target: String,
}

#[derive(Debug)]
struct Workflow {
    rules: Vec<Rule>,
    default: String
}

fn parse(input: &str) -> (HashMap<&str, Workflow>, Vec<HashMap<&str, u32>>) {
    let re_workflow: Regex = Regex::new(r"([A-z]+)\{(.+),([A-z]+)\}").unwrap();
    let re_rule: Regex = Regex::new(r"([A-z]+)([<>])([0-9]+)\:([A-z]+)").unwrap();
    let re_parts: Regex = Regex::new(r"\{x=([0-9]+),m=([0-9]+),a=([0-9]+),s=([0-9]+)\}").unwrap();

    let rules_map: HashMap<&str, Workflow> =
        re_workflow.captures_iter(input).map(|c| c.extract()).map(|(_, [name, rules, default])| {
            let rules_vec = re_rule.captures_iter(rules).map(|c| c.extract()).map(|(_, [v, c, e, t])| {
                return Rule { variable: v.to_owned(), condition: c.to_owned(), expected_value: e.parse().unwrap(), target: t.to_owned() };
            }).collect();
            return (name, Workflow { rules: rules_vec, default: default.to_owned() });
        }).collect();

    let parts: Vec<HashMap<&str, u32>> =
        re_parts.captures_iter(input).map(|c| c.extract()).map(|(_, [x, m, a, s])| {
            return HashMap::from([("x", x.parse::<u32>().unwrap()), ("m", m.parse::<u32>().unwrap()), ("a", a.parse::<u32>().unwrap()), ("s", s.parse::<u32>().unwrap())]);
        }).collect();

    return (rules_map, parts);
}

fn part_1(input: &str) -> u32 {
    let (rules_map, parts) = parse(input);

    let mut total_rating: u32 = 0;

    'part: for part in parts {
        let mut workflow_id: &str = "in";
        'workflow: loop {
            if workflow_id.eq("A") {
                total_rating += part.values().sum::<u32>();
                continue 'part;
            } else if workflow_id.eq("R") {
                continue 'part;
            }

            let workflow: &Workflow = rules_map.get(workflow_id).unwrap();
            'rule: for rule in workflow.rules.iter() {
                let variable: u32 = *part.get(rule.variable.as_str()).unwrap();
                match rule.condition.as_str() {
                    ">" => {
                        if variable > rule.expected_value {
                            workflow_id = &rule.target;
                            continue 'workflow;
                        }
                    },
                    "<" => {
                        if variable < rule.expected_value {
                            workflow_id = &rule.target;
                            continue 'workflow;
                        }
                    },
                    _ => panic!(),
                }
            }
            workflow_id = workflow.default.as_str();
        }
    }

    return total_rating;
}

fn part_2(input: &str) -> u64 {
    let (rules_map, _) = parse(input);

    let part_ranges: HashMap<&str, (u32, u32)> = HashMap::from([
        ("x", (1, 4000)),
        ("m", (1, 4000)),
        ("a", (1, 4000)),
        ("s", (1, 4000)),
    ]);

    let mut state_queue: VecDeque<(&str, HashMap<&str, (u32, u32)>)> = VecDeque::from([("in", part_ranges)]);
    let mut accepted_states: Vec<HashMap<&str, (u32, u32)>> = Vec::new();

    while !state_queue.is_empty() {
        match state_queue.pop_front() {
            Some((workflow_id, mut range_state)) => {
                let workflow: &Workflow = rules_map.get(workflow_id).unwrap();

                for rule in workflow.rules.iter() {
                    let mut target_range_state: HashMap<&str, (u32, u32)> = range_state.clone();

                    match rule.condition.as_str() {
                        ">" => {
                            range_state.get_mut(&rule.variable.as_str()).unwrap().1 = rule.expected_value;

                            match rule.target.as_str() {
                                "R" => { },
                                "A" => {
                                    target_range_state.get_mut(&rule.variable.as_str()).unwrap().0 = rule.expected_value + 1;
                                    accepted_states.push(target_range_state);
                                },
                                target => {
                                    target_range_state.get_mut(&rule.variable.as_str()).unwrap().0 = rule.expected_value + 1;
                                    state_queue.push_back((target, target_range_state));
                                },
                            }
                        },
                        "<" => {
                            range_state.get_mut(&rule.variable.as_str()).unwrap().0 = rule.expected_value;

                            match rule.target.as_str() {
                                "R" => { },
                                "A" => {
                                    target_range_state.get_mut(&rule.variable.as_str()).unwrap().1 = rule.expected_value - 1;
                                    accepted_states.push(target_range_state);
                                },
                                target => {
                                    target_range_state.get_mut(&rule.variable.as_str()).unwrap().1 = rule.expected_value - 1;
                                    state_queue.push_back((target, target_range_state));
                                },
                            }
                        },
                        _ => panic!(),
                    }
                }
                match workflow.default.as_str() {
                    "R" => { },
                    "A" => { accepted_states.push(range_state) },
                    default => { state_queue.push_back((default, range_state)) },
                }
            },
            None => { break },
        }
    }

    return accepted_states.iter()
                          .map(|states: &HashMap<&str, (u32, u32)>| { states.values().map(|(a, b)| (b - a + 1) as u64).product::<u64>() })
                          .sum();
}

fn main() {
    let test_input: &str = r"px{a<2006:qkq,m>2090:A,rfg}
                             pv{a>1716:R,A}
                             lnx{m>1548:A,A}
                             rfg{s<537:gd,x>2440:R,A}
                             qs{s>3448:A,lnx}
                             qkq{x<1416:A,crn}
                             crn{x>2662:A,R}
                             in{s<1351:px,qqz}
                             qqz{s>2770:qs,m<1801:hdj,R}
                             gd{a>3333:R,R}
                             hdj{m>838:A,pv}

                             {x=787,m=2655,a=1222,s=2876}
                             {x=2036,m=264,a=79,s=2244}
                             {x=2461,m=1339,a=466,s=291}
                             {x=2127,m=1623,a=2188,s=1013}";

    assert_eq!(part_1(test_input), 19_114);
    assert_eq!(part_2(test_input), 167_409_079_868_000);

    let input: String = std::fs::read_to_string("day19/src/input.txt").expect("Failed reading file");

    println!("⭐️: {}", part_1(&input));
    println!("⭐️: {}", part_2(&input));
}
