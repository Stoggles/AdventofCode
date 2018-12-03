import copy
import random

current_best_cost = 100000000

class spell:
    def __init__(self, name, cost, damage=0, heal=0, mana=0, armor=0, duration=1):
        self.name = name
        self.cost = cost
        self.damage = damage
        self.heal = heal
        self.mana = mana
        self.armor = armor
        self.duration = duration

class actor:
    def __init__(self, name, hp, mana=0, armor=0, damage=0):
        self.name = name
        self.hp = hp
        self.mana = mana
        self.armor = armor
        self.damage = damage

def do_simulation(spell_list, player, boss, part_2 = False):
    spell_index = 0
    total_mana_cost = 0
    active_effects = []

    if sum([spell.damage * spell.duration for spell in spell_list]) < boss.hp:
        return False

    while boss.hp > 0:
        # player turn
        if part2:
            player.hp -= 1
            # print 'hard mode damages player for 1', player.hp

        if player.hp <= 0:
            # print 'player died'
            return False

        do_effects(active_effects, player, boss)

        if boss.hp <= 0:
            break

        if spell_index < len(spell_list):
            next_spell = spell_list[spell_index]
            spell_index+=1
        else:
            # print 'out of spells'
            return False

        if player.mana < next_spell.cost:
            # print 'out of mana'
            return False

        player.mana -= next_spell.cost
        total_mana_cost += next_spell.cost

        # print 'casting', next_spell.name, 'cost', next_spell.cost, player.mana

        if total_mana_cost > current_best_cost:
            return False

        if next_spell.duration > 1:
            if next_spell.name in [effect.name for effect in active_effects]:
                # print 'effect overwrite not allowed'
                return False

            active_effects.append(copy.deepcopy(next_spell))
        else:
            boss.hp -= next_spell.damage
            player.hp += next_spell.heal

        # boss turn
        do_effects(active_effects, player, boss)

        if boss.hp <= 0:
            break

        if 'Shield' in [effect.name for effect in active_effects]:
            player.armor = sum([effect.armor for effect in active_effects])
        else:
            player.armor = 0

        player.hp -= max((boss.damage - player.armor), 1)

    print player.hp, boss.hp, total_mana_cost
    return total_mana_cost

def do_effects(active_effects, player, boss):
    for effect in active_effects:
        player.mana += effect.mana
        boss.hp -= effect.damage
        effect.duration -= 1
        # print effect.name, 'remaining duration', effect.duration
    for effect in active_effects:
        if effect.duration == 0:
            # print effect.name, 'ended, removing from active effects list'
            active_effects.remove(effect)

spells = [
    spell('Magic Missile', cost=53, damage=4),
    spell('Drain', cost=73, damage=2, heal=2),
    spell('Shield', cost=113, armor=7, duration=6),
    spell('Poison', cost=173, damage=3, duration=6),
    spell('Recharge', cost=229, mana=101, duration=5),
]

for i in range(1000000):

    spell_list = []

    for x in range(20):
        spell_list.append(random.choice(spells))

    player = actor('player', hp=50, mana=500)
    boss = actor('boss', hp=51, damage=9)

    cost = do_simulation(spell_list, player, boss, True)

    if cost and cost < current_best_cost:
        print [spell.name for spell in spell_list]
        current_best_cost = cost

print current_best_cost
