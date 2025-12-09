import re

def part1(data: List[str]) -> int:
    password = 0
    pos = 50
    n = 100

    for line in data:
        m = re.search('(L|R)(\\d+)', line)
        d = -1 if m.group(1) == 'L' else 1
        s = int(m.group(2))

        pos = (pos + s * d) % n
        password += (pos == 0)

    return password

def part2(data: List[str]) -> int:
    password = 0
    pos = 50
    n = 100

    for line in data:
        m = re.search('(L|R)(\\d+)', line)
        d = -1 if m.group(1) == 'L' else 1
        s = int(m.group(2))

        rotations, partial = divmod(s, n)
        partial *= d

        if pos + partial >= n or (pos > 0 and pos + partial <= 0):
            rotations += 1

        pos = (pos + partial) % n
        password += rotations

    return password

with open('test01.txt', encoding='utf-8') as test01:
    lines = list(test01)
    assert part1(lines) == 3
    assert part2(lines) == 6

with open('input01.txt', encoding='utf-8') as input01:
    lines = list(input01)
    print(f'🌟: {part1(lines)}')
    print(f'🌟: {part2(lines)}')
