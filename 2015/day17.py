import itertools

test1 = [[20, 15, 10, 5, 5], 25, 4]
test2 = [[20, 15, 10, 5, 5], 25, 3]

def parse_file(file):
	containers = []

	for line in file:
		containers.append(int(line))

	return containers

def count_combinations(containers, volume):
	total = 0

	for i in range(len(containers)):
		for permutation in itertools.combinations(containers, i):
			if sum(permutation) == volume:
				total += 1

	return total

def count_combinations_part2(containers, volume):
	total = 0

	for i in range(len(containers)):
		for permutation in itertools.combinations(containers, i):
			if sum(permutation) == volume:
				total += 1
		if total > 0:
			break

	return total

assert count_combinations(test1[0], test1[1]) == test1[2]
assert count_combinations_part2(test2[0], test2[1]) == test2[2]

with open('input17.txt') as file:
	containers = parse_file(file)

print count_combinations(containers, 150)
print count_combinations_part2(containers, 150)
