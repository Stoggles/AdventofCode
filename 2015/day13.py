import re
import itertools

def parse_file(file):
	pairings = []

	for line in file:
		details = re.search('([A-Za-z]+) would (gain|lose) ([0-9]+) happiness units by sitting next to ([A-Za-z]+)', line)
		if details.group(2) == 'lose':
			pairings.append([details.group(1),int(details.group(3)) *  -1,details.group(4)])
		else:
			pairings.append([details.group(1),int(details.group(3)),details.group(4)])
	return pairings

def pairwise(iterable):
	iterable += (iterable[0],)
	a, b = itertools.tee(iterable)
	next(b, None)

	return zip(a, b)

def happiness_cache(pairings):
	cache = {}
	for pair in pairings:
		people = ''.join(sorted([pair[0], pair[2]]))
		if people in cache.keys():
			cache[people] += pair[1]
		else:
			cache[people] = pair[1]

	return cache

def permutate(pairings, include_host=False):
	people = []
	totals = []

	for pair in pairings:
		people.append(pair[0])
		people.append(pair[2])
	set_people = set(people)

	cache = happiness_cache(pairings)

	if include_host:
		for person in set_people:
			cache[''.join(sorted([person,'host']))] = 0
		set_people.add('host')

	for permutation in itertools.permutations(set_people):
		total = 0
		for pair in pairwise(permutation):
			total += cache[''.join(sorted(pair))]
		totals.append(total)

	return max(totals)

with open('test13.txt') as file:
	pairings = parse_file(file)
	print permutate(pairings)

with open('input13.txt') as file:
	pairings = parse_file(file)
	print permutate(pairings)
	print permutate(pairings, True)
