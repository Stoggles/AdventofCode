import json

def decode_elements(element, ignore_red=False):
	global total
	if isinstance(element, list):
		for item in element:
			decode_elements(item, ignore_red)

	if isinstance(element, dict):
		if ignore_red and "red" in element.values():
			return
		for key in element.keys():
			decode_elements(element[key], ignore_red)

	if isinstance(element, int):
		total += element

	return

with open('input12.txt') as file:
	parsed_json = json.load(file)

total = 0

decode_elements(parsed_json)

print total

total = 0

decode_elements(parsed_json, True)

print total
