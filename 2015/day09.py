import re
import itertools

def parse_file(file):
	distances = []

	for line in file:
		details = re.search('([A-Za-z]+) to ([A-Za-z]+) = ([0-9]+)', line)
	 	distances.append(details.groups())
	return distances

def pairwise(iterable):
    a, b = itertools.tee(iterable)
    next(b, None)
    return itertools.izip(a, b)

def get_distance(pair, distances):
	for distance in distances:
		if set(pair) == set(distance[0:2]):
			return int(distance[2])

def permutate(distances):
	locations = []
	totals = []

	for distance in distances:
		locations.append(distance[0])
		locations.append(distance[1])
	set_loc = set(locations)

	for permutation in itertools.permutations(set_loc):
		total = 0
		for pair in pairwise(permutation):
			total += get_distance(pair, distances)
		totals.append(total)

	return min(totals), max(totals)

with open('test9.txt') as file:
	distances = parse_file(file)

assert permutate(distances) == (605, 982)

with open('input9.txt') as file:
	distances = parse_file(file)

print permutate(distances)
