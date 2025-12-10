from collections import defaultdict

def parse(data: List[str]) -> dict[(int, int), int]:
    grid = dict()

    line_no = 0
    for line in data.readlines():
        char_no = 0
        for char in line:
            if char == '@':
                grid[(char_no, line_no)] = 1
            char_no += 1
        line_no += 1

    return grid

def part1(grid: dict[(int, int), int]) -> int:
    rolls = 0

    for key in grid.keys():
        adjacent_count = 0
        for x in range(-1, 2, 1):
            for y in range(-1, 2, 1):
                if x == 0 and y == 0:
                    continue
                adjacent_count += grid.get((key[0] + x, key[1] + y)) or 0
        rolls += 1 if adjacent_count < 4 else 0

    return rolls

def part2(grid: dict[(int, int), int]) -> int:
    rolls_removed = 0

    while True:
        to_be_removed = list()

        for key in grid.keys():
            adjacent_count = 0
            for x in range(-1, 2, 1):
                for y in range(-1, 2, 1):
                    if x == 0 and y == 0:
                        continue
                    adjacent_count += grid.get((key[0] + x, key[1] + y)) or 0
            if adjacent_count < 4:
                to_be_removed.append(key)

        for roll in to_be_removed:
            grid.pop(roll)

        if len(to_be_removed) == 0:
            break
        else:
            rolls_removed += len(to_be_removed)

    return rolls_removed

with open('test04.txt', encoding='utf-8') as test04:
    grid = parse(test04)
    assert part1(grid) == 13
    assert part2(grid) == 43

with open('input04.txt', encoding='utf-8') as input04:
    grid = parse(input04)
    print(f'🌟: {part1(grid)}')
    print(f'🌟: {part2(grid)}')
