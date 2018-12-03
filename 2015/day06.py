import re

x_len = 1000
y_len = 1000

lights = [[0 for y in range(y_len)] for x in range(x_len)]
brightness = [[0 for y in range(y_len)] for x in range(x_len)]

def parse_instruction(instruction):
	details = re.search('([a-z ]+) (\d+,\d+)[a-z ]+(\d+,\d+)', instruction)
	command =  details.group(1)
	start = details.group(2).split(',')
	stop = details.group(3).split(',')

	return command, start, stop


def do_instruction(instruction):
	command, start, stop = parse_instruction(instruction)

	for x in xrange(int(start[0]), int(stop[0])+1):
		for y in xrange(int(start[1]), int(stop[1])+1):
			if command == 'turn on':
				lights[x][y] = 1
			elif command == 'turn off':
				lights[x][y] = 0
			elif command == 'toggle':
				lights[x][y] = 1 - lights[x][y]

def do_brightness(instruction):
	details = re.search('([a-z ]+) (\d+,\d+)[a-z ]+(\d+,\d+)', instruction)
	command =  details.group(1)
	start = details.group(2).split(',')
	stop = details.group(3).split(',')

	for x in xrange(int(start[0]), int(stop[0])+1):
		for y in xrange(int(start[1]), int(stop[1])+1):
			if command == 'turn on':
				brightness[x][y] += 1
			elif command == 'turn off':
				if brightness[x][y] > 0:
					brightness[x][y] -= 1
			elif command == 'toggle':
				brightness[x][y] += 2

with open('input06.txt') as file:
	for line in file:
		do_instruction(line)
		do_brightness(line)

total_lights = 0
total_brightness = 0

for x in xrange(x_len):
	for y in xrange(y_len):
		total_lights += lights[x][y]
		total_brightness += brightness[x][y]

print total_lights
print total_brightness
