test1 = ['>', 2]
test2 = ['^>v<', 4]
test3 = ['^v^v^v^v^v', 2]

test4 = ['^v', 3]
test5 = ['^>v<', 3]
test6 = ['^v^v^v^v^v', 11]

def do_move(direction, starting_coords):
	if (direction == '>'):
		starting_coords[0] += 1
	elif (direction == '<'):
		starting_coords[0] -= 1
	elif (direction == '^'):
		starting_coords[1] += 1
	elif (direction == 'v'):
		starting_coords[1] -= 1

	return [starting_coords[0], starting_coords[1]]

def santa(input):
	current_coords = [0,0]
	houses = [[0,0]]

	for char in input:
		houses.append(do_move(char, current_coords))

	unique_houses = []

	for house in houses:
		if house not in unique_houses:
			unique_houses.append(house)

	return len(unique_houses)

def robo_santa(input):
	santa_coords = [0,0]
	robo_santa_coords = [0,0]
	houses = [[0,0],[0,0]]

	for i in xrange(len(input)):
		char = input[i]
		if i % 2 == 0:
			houses.append(do_move(char, santa_coords))
		else:
			houses.append(do_move(char, robo_santa_coords))

	unique_houses = []

	for house in houses:
		if house not in unique_houses:
			unique_houses.append(house)

	return len(unique_houses)

assert santa(test1[0]) == test1[1]
assert santa(test2[0]) == test2[1]
assert santa(test3[0]) == test3[1]

assert robo_santa(test4[0]) == test4[1]
assert robo_santa(test5[0]) == test5[1]
assert robo_santa(test6[0]) == test6[1]

with open('input3.txt') as file:
	data = file.readline()
	print "Total houses visited by Santa: ", santa(data)
	print "Total houses visited by Santa and Robo-Santa:", robo_santa(data)
