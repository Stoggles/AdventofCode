def parse(data: List[str]) -> List[str]:
    return [line.rstrip() for line in data.readlines()]

def part1(banks: List[str]) -> int:
    jolts = 0

    for bank in banks:
        ints = [int(x) for x in bank]

        max_l = max(ints[:len(ints) - 1])
        index_l = ints.index(max_l)
        max_r = max(ints[index_l + 1:])

        jolts += max_l * 10 + max_r

    return jolts

def part2(banks: List[str]) -> int:
    jolts = 0

    for bank in banks:
        ints = [int(x) for x in bank]
        start_index = 0

        for x in range(12, 0, -1):
            max_j = max(ints[start_index:len(ints) - x + 1])
            start_index = ints.index(max_j, start_index) + 1
            jolts += max_j * (10 ** (x - 1))

    return jolts

with open('test03.txt', encoding='utf-8') as test03:
    banks = parse(test03)
    assert part1(banks) == 357
    assert part2(banks) == 3121910778619

with open('input03.txt', encoding='utf-8') as input03:
    banks = parse(input03)
    print(f'🌟: {part1(banks)}')
    print(f'🌟: {part2(banks)}')
