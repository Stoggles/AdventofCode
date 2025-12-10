def parse(data: list[str]) -> set[(int, int)]:
    grid = set()

    line_no = 0
    for line in data.readlines():
        char_no = 0
        for char in line:
            if char == '@':
                grid.add((char_no, line_no))
            char_no += 1
        line_no += 1

    return grid

def part1(grid: set[(int, int)]) -> int:
    rolls = 0

    for coord in grid:
        adjacent_count = 0
        for x in range(-1, 2, 1):
            for y in range(-1, 2, 1):
                if x == 0 and y == 0:
                    continue
                adjacent_count += 1 if (coord[0] + x, coord[1] + y) in grid else 0
        rolls += 1 if adjacent_count < 4 else 0

    return rolls

def part2(grid: set[(int, int)]) -> int:
    rolls_removed = 0

    while True:
        to_be_removed = []

        for coord in grid:
            adjacent_count = 0
            for x in range(-1, 2, 1):
                for y in range(-1, 2, 1):
                    if x == 0 and y == 0:
                        continue
                    adjacent_count += 1 if (coord[0] + x, coord[1] + y) in grid else 0
            if adjacent_count < 4:
                to_be_removed.append(coord)

        for roll in to_be_removed:
            grid.remove(roll)

        if len(to_be_removed) == 0:
            break

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
