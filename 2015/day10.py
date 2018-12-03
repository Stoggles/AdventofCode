test1 = [1, '11']
test2 = [11, '21']
test3 = [21, '1211']
test4 = [1211, '111221']
test5 = [111221, '312211']

def look_say(input):
	string = str(input)
	string_length = len(string)

	count = 1
	elements = []
	for position in xrange(string_length):
		if position < string_length - 1 and string[position] == string[position + 1]:
			count += 1
		else:
			elements.append(str(count))
			elements.append(string[position])
			count = 1

	output = ''.join(elements)

	return output

assert look_say(test1[0]) == test1[1]
assert look_say(test2[0]) == test2[1]
assert look_say(test3[0]) == test3[1]
assert look_say(test4[0]) == test4[1]
assert look_say(test5[0]) == test5[1]

input = 1113222113

for i in xrange(40):
	input = look_say(input)

print len(input)

input = 1113222113

for i in xrange(50):
	input = look_say(input)

print len(input)
