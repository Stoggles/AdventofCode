import math

def solve(problem: list[str]) -> int:
    if problem[-1] == '+':
        return sum([int(op) for op in problem[:-1]])
    elif problem[-1] == '*':
        return math.prod([int(op) for op in problem[:-1]])

def sum_results(problems: list[list[str]]) -> int:
    return sum([solve(problem) for problem in problems])

def part1(lines: list[str]) -> int:
    problems = []

    for line in lines:
        prob_number = 0
        for op in line.split():
            if len(problems) <= prob_number:
                problems.append([])
            problems[prob_number].append(op)
            prob_number += 1

    return sum_results(problems)

def part2(lines: list[str]) -> int:
    problems = []

    line_length = len(lines[0])

    problem = []
    for i in range(0, line_length):
        operand = []
        for j in range(0, len(lines) - 1):
            operand.append(lines[j][i])

        if all(c.isspace() for c in operand):
            problems.append(problem)
            problem = []
        else:
            problem.append(int(''.join(operand)))

    [problem.append(operand) for problem, operand in zip(problems, lines[-1].split())]

    return sum_results(problems)



with open('test06.txt', encoding='utf-8') as test06:
    lines = list(test06.readlines())
    assert part1(lines) == 4277556
    assert part2(lines) == 3263827

with open('input06.txt', encoding='utf-8') as input06:
    lines = list(input06.readlines())
    print(f'🌟: {part1(lines)}')
    print(f'🌟: {part2(lines)}')
