def next_coordinate(x, y):
	if y == 1:
		new_x = 1
		new_y = x + 1
	else:
		new_x = x + 1
		new_y = y - 1

	return new_x, new_y

def next_code(previous_code):
	return (previous_code * 252533) % 33554393

x = 1
y = 1
code = 20151125
target_x = 3019
target_y = 3010

while True:
	x, y = next_coordinate(x,y)
	code = next_code(code)
	if x == target_x and y == target_y:
		print code
		break
