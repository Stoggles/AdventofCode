test1 = ['(())', 0]
test2 = ['()()', 0]
test3 = ['(((', 3]
test4 = ['(()(()(', 3]
test5 = ['))(((((', 3]
test6 = ['())', -1]
test7 = ['))(', -1]
test8 = [')))', -3]
test9 = [')())())', -3]
test10 = [')', 1]
test11 = ['()())', 5]


def floor(data):
	floor = 0

	for i in range (0, len(data)):
		if data[i] == '(':
			floor += 1
		elif data[i] == ')':
			floor -= 1

	return floor

def basement(data):
	floor = 0

	for i in range (0, len(data)):
		if data[i] == '(':
			floor += 1
		elif data[i] == ')':
			floor -= 1
		if floor == -1:
			return i+1

assert floor(test1[0]) == test1[1]
assert floor(test2[0]) == test2[1]
assert floor(test3[0]) == test3[1]
assert floor(test4[0]) == test4[1]
assert floor(test5[0]) == test5[1]
assert floor(test6[0]) == test6[1]
assert floor(test7[0]) == test7[1]
assert floor(test8[0]) == test8[1]
assert floor(test9[0]) == test9[1]
assert basement(test10[0]) == test10[1]
assert basement(test11[0]) == test11[1]

with open('input1.txt') as file:
	data = file.readline()
	print "Final floor: ", floor(data)
	print "Passing floor -1: ", basement(data)

