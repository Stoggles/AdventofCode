import hashlib

test1 = ['abcdef', 609043]
test2 = ['pqrstuv', 1048970]

def hash(input, num_zeros):
	i = 0
	hash = ''
	while not hash.startswith('0' * num_zeros):
		i += 1
		m = hashlib.md5('%s%s' % (input, i))
		hash = m.hexdigest()
	return i

assert hash(test1[0], 5) == test1[1]
assert hash(test2[0], 5) == test2[1]

with open('input4.txt') as file:
	data = file.readline().strip()
	print hash(data, 5)
	print hash(data, 6)
