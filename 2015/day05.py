test1 = ['ugknbfddgicrmopn', 1]
test2 = ['aaa', 1]
test3 = ['jchzalrnumimnmhp', 0]
test4 = ['haegwjzuvuyypxyu', 0]
test5 = ['dvszwmarrgswjxmb', 0]

test6 = ['qjhvhtzxzqqjkmpb', 1]
test7 = ['xxyxx', 1]
test8 = ['uurcxstgmygtbstg', 0]
test9 = ['ieodomkazucvgmuy', 0]


def nice(string):
	vowels = 0
	double = False

	str_len = len(string)

	for i in xrange(str_len):
		if string[i] in 'aeiou':
			vowels += 1
		if i < str_len - 1:
			if string[i] == string[i+1]:
				double = True
			if string[i:i+2] in ['ab', 'cd', 'pq', 'xy']:
				return 0

	if vowels >= 3 and double:
		return 1
	else:
		return 0

def nice2(string):
	double_pair = False
	repeat = False

	str_len = len(string)

	for i in xrange(str_len-1):
		substring = '%s%s%s' % (string[0:i], '  ', string[i+2:str_len+1])
		if string[i:i+2] in substring:
			double_pair = True
		if i < str_len - 2:
			if string[i] == string[i+2]:
				repeat = True

	if double_pair and repeat:
		return 1
	else:
		return 0

# assert nice(test1[0]) == test1[1]
# assert nice(test2[0]) == test2[1]
# assert nice(test3[0]) == test3[1]
# assert nice(test4[0]) == test4[1]
# assert nice(test5[0]) == test5[1]

# assert nice2(test6[0]) == test6[1]
# assert nice2(test7[0]) == test7[1]
# assert nice2(test8[0]) == test8[1]
# assert nice2(test9[0]) == test9[1]

with open('input5.txt') as file:
	total1 = 0
	total2 = 0
	for line in file:
		total1 += nice(line)
		total2 += nice2(line)

print total1
print total2
