import re

def parse_file(file):
	sues = []

	for line in file:
		details = re.search('Sue ([0-9]+): ([a-z]+): ([0-9]+), ([a-z]+): ([0-9]+), ([a-z]+): ([0-9]+)', line)

		sues.append({'sue': int(details.group(1)), details.group(2): int(details.group(3)), details.group(4): int(details.group(5)), details.group(6): int(details.group(7))})

	return sues

def find_sue(known_sue, sues, details=False):
	for sue in sues:
		matches = 0
		for key in sue.keys():
			if key == 'sue':
				continue

			if details:
				if key in ['cats', 'trees']:
					if sue[key] <= known_sue[key]:
						continue
				elif key in ['pomeranians', 'goldfish']:
					if sue[key] >= known_sue[key]:
						continue
				else:
					if sue[key] != known_sue[key]:
						continue
			else:
				if sue[key] != known_sue[key]:
					continue

			matches += 1

		if matches == 3:
			print sue['sue']

with open('input16.txt') as file:
	sues = parse_file(file)

known_sue = {'children': 3, 'cats': 7, 'samoyeds': 2, 'pomeranians': 3, 'akitas': 0, 'vizslas': 0, 'goldfish': 5, 'trees': 3, 'cars': 2, 'perfumes': 1}

find_sue(known_sue, sues)
find_sue(known_sue, sues, True)

# In particular, the cats and trees readings indicates that there are greater than that many
# (due to the unpredictable nuclear decay of cat dander and tree pollen), while the pomeranians
# and goldfish readings indicate that there are fewer than that many (due to the modial interaction of magnetoreluctance).
