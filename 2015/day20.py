import math

def find_divisors(value):
	divisors = []
	large_divisors = []

	for i in range(1, int(math.sqrt(value) + 1)):
		if value % i == 0:
			divisors.append(i)
			if i*i != value:
				large_divisors.append(value / i)

	for divisor in reversed(large_divisors):
		divisors.append(divisor)

	return divisors

def count_presents(house_number, elf_multipler, part_2):
	elves = find_divisors(house_number)

	if not part_2:
		total_presents = sum(elves) * elf_multipler
	else:
		total_presents = sum(e for e in elves if house_number / e <= 50) * elf_multipler

	return total_presents

def find_house(max_presents, elf_multipler, part_2=False):
	i = 1

	while(count_presents(i, elf_multipler, part_2) < max_presents):
		i += 1

	return i

print find_house(34000000, 10)
print find_house(34000000, 11, True)
