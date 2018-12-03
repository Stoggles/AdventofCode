from itertools import combinations

def parse_file(file):
    presents = []

    for line in file:
        presents.append(int(line))

    return presents

with open('input24.txt') as file:
    presents = parse_file(file)

quantum_entanglement = lambda l: reduce(int.__mul__, l, 1)

def valid_split(source_list, target_size, parts):
    for i in range(1, len(source_list) - parts + 1):
        c = [r for r in combinations(source_list, i) if sum(r) == target_size]
        for result in c:
            if parts == 2 and sum(source_list) - sum(result) == target_size:
                return True
            elif valid_split(set(source_list) - set(result), target_size, parts - 1):
                return True
    return False

def solve(source_list, parts):
    target_size = sum(source_list) // parts
    for i in range(1, len(source_list)):
        c = [r for r in combinations(source_list, i) if sum(r) == target_size]
        s = sorted(c, key = quantum_entanglement)
        for result in s:
            if valid_split(set(source_list) - set(result), target_size, parts - 1):
                return quantum_entanglement(result)

print solve(presents, 3)
print solve(presents, 4)
