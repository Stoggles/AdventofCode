import re

def parse_file(file):
	instructions = []

	for line in file:
		details = re.search('([a-z]{3}) ([a-z]|[+-][0-9]+)(?:, ([+-][0-9]+))?', line)

		if details.group(3):
			instructions.append([details.group(1), details.group(2), int(details.group(3))])
		else:
			try:
				instructions.append([details.group(1), int(details.group(2))])
			except ValueError:
				instructions.append([details.group(1), details.group(2)])

	return instructions

def run_instructions(registers, instructions):

	instruction_pointer = 0

	while True:
		try:
			instruction = instructions[instruction_pointer]
		except IndexError:
			return registers

		if instruction[0] == 'hlf':
			registers[instruction[1]] = registers[instruction[1]] // 2
		elif instruction[0] == 'tpl':
			registers[instruction[1]] = registers[instruction[1]] * 3
		elif instruction[0] == 'inc':
			registers[instruction[1]] = registers[instruction[1]] + 1
		elif instruction[0] == 'jmp':
			instruction_pointer += instruction[1]
			continue
		elif instruction[0] == 'jie':
			if registers[instruction[1]] % 2 == 0:
				instruction_pointer += instruction[2]
				continue
		elif instruction[0] == 'jio':
			if registers[instruction[1]] == 1:
				instruction_pointer += instruction[2]
				continue

		instruction_pointer += 1

with open('test23.txt') as file:
	instructions = parse_file(file)

registers = {'a': 0, 'b': 0}
print run_instructions(registers, instructions)

with open('input23.txt') as file:
	instructions = parse_file(file)

registers = {'a': 0, 'b': 0}
print run_instructions(registers, instructions)

registers = {'a': 1, 'b': 0}
print run_instructions(registers, instructions)
