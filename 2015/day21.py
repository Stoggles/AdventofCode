import itertools
import re

def parse_file(file):
	weapons = []
	armor = []
	rings = []

	for line in file:
		if line.startswith('Weapons'):
			target = weapons
		elif line.startswith('Armor'):
			target = armor
		elif line.startswith('Rings'):
			target = rings

		details = re.search('[A-Za-z]+(?: \+\d+)?\s+(\d+)\s+(\d+)\s+(\d+)', line)

		if details:
			target.append([int(detail) for detail in details.groups()])

	return weapons, armor, rings

def select_loadout(weapons, armor, rings):
	for weapon in weapons:
		for i in range(2):
			for piece in itertools.combinations(armor, i):
				for i in range(3):
					for ring in itertools.combinations(rings, i):
						yield [weapon] + [i for i in piece] + [j for j in ring]

def do_simulation(player, boss):
	player_hp = player[0]
	player_damage = player[1]
	player_armor = player[2]

	boss_hp = boss[0]
	boss_damage = boss[1]
	boss_armor = boss[2]

	next_turn = 'player'

	while player_hp > 0 and boss_hp	> 0:
		if next_turn == 'player':
			boss_hp -= max((player_damage - boss_armor), 1)
			next_turn = 'boss'
		else:
			player_hp -= max((boss_damage - player_armor), 1)
			next_turn = 'player'

	return player_hp > 0

assert do_simulation([8, 5, 5], [12, 7, 2]) == True

with open('input21.txt') as file:
	weapons, armor, rings = parse_file(file)

success_costs = []
failure_costs = []

for loadout in select_loadout(weapons, armor, rings):
	player = [100, sum([int(l[1]) for l in loadout]), sum([int(l[2]) for l in loadout])]
	boss = [100, 8, 2]
	cost = sum([int(l[0]) for l in loadout])
	if do_simulation(player, boss):
		success_costs.append(cost)
	else:
		failure_costs.append(cost)

print min(success_costs)
print max(failure_costs)
