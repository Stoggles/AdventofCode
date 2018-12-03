import re

alphabet = "abcdefghijklmnopqrstuvwxyz"
forbidden_characters = ['i', 'o', 'l']

def plusOne(string):
	if len(string) == 0:
		return 'a'
	if string[-1] != 'z':
		return string[:len(string)-1] + alphabet[alphabet.index(string[-1]) + 1]
	else:
		return plusOne(string[:len(string)-1]) + 'a'

def checkPassword(password):
	if any(character in password for character in forbidden_characters):
		return False

	if len(re.findall(r'([a-z]{1})\1', password)) < 2:
		return False

	for i in xrange(len(password)-2):
		if alphabet.index(password[i+1]) == alphabet.index(password[i])+1 and alphabet.index(password[i+2]) == alphabet.index(password[i])+2:
			return True

	return False

password = 'hxbxwxba'

steps = 0
while not checkPassword(password):
	password = plusOne(password)
	steps += 1

print password, 'in', steps, 'steps'

password = plusOne(password)
while not checkPassword(password):
	password = plusOne(password)
	steps += 1

print password, 'in', steps, 'steps'
