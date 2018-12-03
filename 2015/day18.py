def parse_file(file):
	state = []

	for line in file:
		state.append([int(char == '#') for char in line.strip()])

	return state

def step(state, part2):
	new_state = [[0 for x in range(len(state))] for y in range(len(state[0]))]

	for x in range(len(state)):
		for y in range(len(state[0])):
			# proper python list compresion magic, but just too damn slow
			# total = sum([state[_x][_y] for _x in range(max(x - 1, 0), min(x + 2, len(state))) for _y in range(max(y - 1, 0), min(y + 2, len(state))) if (_x,_y) != (x, y)])

			total = 0
			for xs in range(max(x - 1, 0), min(x + 2, len(state))):
				for ys in range(max(y - 1, 0), min(y + 2, len(state[0]))):
					if xs == x and ys == y:
						continue
					total += state[xs][ys]

			if part2 and (x == 0 or x == len(state) - 1) and (y == 0 or y == len(state) - 1):
				new_state[x][y] = 1
			if (state[x][y] == 0 and total == 3) or (state[x][y] == 1 and (total == 2 or total == 3)):
				new_state[x][y] = 1

	return new_state

def do_steps(state, steps, part2=False):
	if part2:
		for i in range(-1, 1):
			for j in range(-1, 1):
				state[i][j] = 1

	for i in range(steps):
		state = step(state, part2)
		i += 1

	return sum(map(sum, state))

with open('test18.txt') as file:
	start_state = parse_file(file)

assert do_steps(start_state, 4) == 4

with open('test18-2.txt') as file:
	start_state = parse_file(file)

assert do_steps(start_state, 5, True) == 17

with open('input18.txt') as file:
	start_state = parse_file(file)

print do_steps(start_state, 100)
print do_steps(start_state, 100, True)
