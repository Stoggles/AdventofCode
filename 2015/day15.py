import re
import operator

def parse_file(file):
	ingredients = []

	for line in file:
		details = re.search('([A-Za-z]+)\: capacity (-?[0-9]+), durability (-?[0-9]+), flavor (-?[0-9]+), texture (-?[0-9]+), calories (-?[0-9]+)', line)

		ingredients.append([int(details.group(2)), int(details.group(3)), int(details.group(4)), int(details.group(5)), int(details.group(6))])

	return ingredients

def little_iterator(limit):
	for a in range (0, limit + 1):
		for b in range (0, limit + 1 - a):
			if (a + b == limit):
				yield [a, b]

def iterator(limit):
	for a in range (0, limit + 1):
		for b in range (0, limit + 1 - a):
			for c in range (0, limit + 1 - a - b):
				for d in range (0, limit + 1 - a - b -c):
					if (a + b + c + d == limit):
						yield [a, b, c, d]

def find_greatest(ingredients, calorie_limit=False):
	max = 0
	for combination in iterator(100):
		subtotals = []
		for i in range(len(ingredients[0])-1): # ignore calories
			subsubtotal = 0
			calories = 0
			for j in range(len(ingredients)):
				subsubtotal += combination[j] * ingredients[j][i]
				calories += combination[j] * ingredients[j][4]

			if subsubtotal < 0 or (calorie_limit and calories != 500):
				subsubtotal = 0

			subtotals.append(subsubtotal)

		total = reduce(operator.mul, subtotals)

		if total > max:
			max = total

	return max

# with open('test15.txt') as file:
# 	ingredients = parse_file(file)

# print find_greatest(ingredients)

with open('input15.txt') as file:
	ingredients = parse_file(file)

print find_greatest(ingredients)
print find_greatest(ingredients, True)
