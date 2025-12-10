def parse(data: list[str]) -> [list[(int, int)], list[int]]:
    ranges, ids = [], []

    for line in data.readlines():
        if '-' in line:
            elements = line.rstrip().split('-')
            ranges.append((int(elements[0]), int(elements[1])))
        elif line.rstrip().isnumeric():
            ids.append(int(line))

    return ranges, ids

def part1(ranges: list[(int, int)], ids: list[int]) -> int:
    fresh_count = 0

    for id in ids:
        try:
            for range in ranges:
                if range[0] <= id <= range[1]:
                    fresh_count += 1
                    raise StopIteration
        except StopIteration:
            continue

    return fresh_count

def part2(ranges: list[(int, int)]) -> int:
    fresh_count = 0

    sorted_ranges = sorted(ranges, key=lambda x: x[0])
    merged_ranges = [sorted_ranges.pop(0)]

    for range in sorted_ranges:
        previous_range = merged_ranges[-1]
        if range[0] >= previous_range[0] and range[1] <= previous_range[1]:
            pass
        elif range[0] <= previous_range[1] and range[1] > previous_range[1]:
            merged_ranges[-1] = (previous_range[0], range[1])
        else:
            merged_ranges.append(range)

    fresh_count = sum([(range[1] - range[0]) + 1 for range in merged_ranges])

    return fresh_count

with open('test05.txt', encoding='utf-8') as test05:
    ranges, ids = parse(test05)
    assert part1(ranges, ids) == 3
    assert part2(ranges) == 14

with open('input05.txt', encoding='utf-8') as input05:
    ranges, ids = parse(input05)
    print(f'🌟: {part1(ranges, ids)}')
    print(f'🌟: {part2(ranges)}')
