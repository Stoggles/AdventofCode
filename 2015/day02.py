test1 = [['2x3x4'], 58, 34]
test2 = [['1x1x10'], 43, 14]

def calc(list):
	areas = []
	lengths = []

	for present in list:
		dimensions = sorted(int(length) for length in present.split('x'))
		areas.append(dimensions[0] * dimensions[1] * 3 + dimensions[0] * dimensions[2] * 2 + dimensions[1] * dimensions[2] * 2) # area of all 6 faces + area of smallest face
		lengths.append((dimensions[0] + dimensions[1]) * 2 + dimensions[0] * dimensions[1] * dimensions[2])						# perimeter of smallest face + volume

	return [sum(areas), sum(lengths)]

assert calc(test1[0]) == [test1[1], test1[2]]
assert calc(test2[0]) == [test2[1], test2[2]]

with open('input2.txt') as file:
	print calc(file)
