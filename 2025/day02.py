import re

def parse(data: List[str]) -> List[tuple]:
    return [(int(range.split('-')[0]),int(range.split('-')[1])) for range in data.readline().split(',')]

def part1(ranges: List[tuple]) -> int:
    invalid_id_sum = 0

    for pair in ranges:
        for i in range(pair[0], pair[1] + 1):
            s = str(i)
            l = len(s)
            if l % 2 == 0 and s[:l // 2] == s[l // 2:]:
                invalid_id_sum += i

    return invalid_id_sum

def segment_list(list: List, segment_size: int) -> List[List]:
    return [list[x:x + segment_size] for x in range(0, len(list), segment_size)]

def part2(data: List[str]) -> int:
    invalid_id_sum = 0

    for pair in ranges:
        for i in range(pair[0], pair[1] + 1):
            s = str(i)
            l = len(s)
            try:
                for x in range(l // 2, 0, -1):
                    segments = segment_list(s, x)
                    if all(segment == segments[0] for segment in segments):
                        invalid_id_sum += i
                        raise StopIteration
            except StopIteration:
                continue

    return invalid_id_sum

with open('test02.txt', encoding='utf-8') as test02:
    ranges = parse(test02)
    assert part1(ranges) == 1227775554
    assert part2(ranges) == 4174379265

with open('input02.txt', encoding='utf-8') as input02:
    ranges = parse(input02)
    print(f'🌟: {part1(ranges)}')
    print(f'🌟: {part2(ranges)}')
