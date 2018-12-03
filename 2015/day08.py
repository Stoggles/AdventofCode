def count_characters(string):
	global total, total_part2
	decode = string.decode('string_escape')
	reencode = line.replace('\\', r'\\').replace('"', r'\"').strip()

	total += len(string)
	total_part2 -= len(string)

	total -= len(decode[1:-1])
	total_part2 += len(reencode) + 2

total = 0
total_part2 = 0

with open('test8.txt') as file:
	for line in file:
		count_characters(line.strip())

assert total == 12
assert total_part2 == 19

total = 0
total_part2 = 0

with open('input8.txt') as file:
	for line in file:
		count_characters(line.strip())

print total
print total_part2
