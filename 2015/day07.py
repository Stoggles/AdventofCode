import re

class command:
	def __init__(self, instruction, args, destination):
		self.instruction = instruction
		self.dependancies = args
		self.destination = destination

data = file('input7.txt').readlines()

def parse_file(file):
	commands = []

	for line in file:
		(src, dst) = line.split(' -> ')
		details = re.search('(\d+|[a-z]+)? ?(?P<instruction>[RL]SHIFT \d+|[A-Z]+)? ?(\d+|[a-z]+)?', src)
		commands.append(command(details.group('instruction'), filter(None, [details.group(1), details.group(3)]), dst.strip()))

	return commands

def do_command(instruction, args):
	if instruction == None:
		return args[0]
	elif 'AND' in instruction:
		return (args[0] & args[1]) & 0xFFFF
	elif 'OR' in instruction:
		return (args[0] | args[1]) & 0xFFFF
	elif 'LSHIFT' in instruction:
		return (args[0] << int(instruction.split(' ')[1])) & 0xFFFF
	elif 'RSHIFT' in instruction:
		return (args[0] >> int(instruction.split(' ')[1])) & 0xFFFF
	elif 'NOT' in instruction:
		return (~args[0]) & 0xFFFF

def get_result(commands, wire):
	if wire in circuit.keys():
		return circuit[wire]
	else:
		for command in commands:
			if command.destination == wire:
				args = []
				for wire in command.dependancies:
					if wire in circuit.keys():
						args.append(circuit[wire])
					elif wire.isdigit():
						args.append(int(wire))
					else:
						args.append(get_result(commands, wire))
				print 'Doing', command.instruction, 'on', args
				circuit[command.destination] = do_command(command.instruction, args)
				return circuit[command.destination]

circuit = {}
commands = parse_file(data)
p1_result = get_result(commands, 'a')
print p1_result

circuit = {}
for command in commands:
	if command.destination == 'b':
		command.dependancies = [str(p1_result)]
p2_result = get_result(commands, 'a')
print p2_result
