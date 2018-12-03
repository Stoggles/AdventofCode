from random import shuffle

def parse_file(file):
	exchanges = []

	for line in file:
		exchanges.append(line.strip().split(' => '))

	return exchanges

def count_exchanges(string, exchanges):
	results = set()

	for src, dst in exchanges:
		for i in xrange(len(string)):
			if string[i:i+len(src)] == src:
				results.add('%s%s%s' % (string[:i], dst, string[i+len(src):]))

	return len(results)

def do_step(molecule, exchanges):
	for src, dst in exchanges:
		for i in xrange(len(molecule)):
			if molecule[i:i+len(dst)] == dst:
				molecule = '%s%s%s' % (molecule[:i], src, molecule[i+len(dst):])
				return molecule

def make_molecule(target, exchanges):
	new_molecule = target

	steps = 0
	while new_molecule != 'e':
		new_molecule = do_step(new_molecule, exchanges)

		if new_molecule == None:
			shuffle(exchanges)
			return make_molecule(target, exchanges)

		steps += 1

	return steps

with open('test19.txt') as file:
	exchanges = parse_file(file)

assert count_exchanges('HOH', exchanges) == 4
assert count_exchanges('HOHOHO', exchanges) == 7

assert make_molecule('HOH', exchanges) == 3
assert make_molecule('HOHOHO', exchanges) == 6

with open('input19.txt') as file:
	exchanges = parse_file(file)

target_molecule = 'ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF'

print count_exchanges(target_molecule, exchanges)
print make_molecule(target_molecule, exchanges)
