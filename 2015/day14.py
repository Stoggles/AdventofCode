import re
import operator

def parse_file(file):
	stats = []

	for line in file:
		details = re.search('([A-Za-z]+) can fly ([0-9]+) km\/s for ([0-9]+) seconds, but then must rest for ([0-9]+) seconds\.', line)

		stats.append([details.group(1), int(details.group(2)), int(details.group(3)), int(details.group(4))])

	return stats

def simulate_time(stats, elapsed_time):
	results = []

	for reindeer in stats:
		cycle_time = reindeer[2] + reindeer[3]
		complete_cycles = elapsed_time // cycle_time
		remainder_seconds = elapsed_time % cycle_time
		total_distance = (reindeer[1] * reindeer[2] * complete_cycles) + (min(remainder_seconds, reindeer[2]) * reindeer[1])

		results.append([reindeer[0], total_distance])

	return max(results, key=operator.itemgetter(1))

def simulate_time_part2(stats, elapsed_time):
	score = {}

	for i in xrange(1,elapsed_time):
		result = simulate_time(stats, i)
		if result[0] in score.keys():
			score[result[0]] += 1
		else:
			score[result[0]] = 1

	return list(max(score.iteritems(), key=operator.itemgetter(1)))


with open('test14.txt') as file:
	stats = parse_file(file)

assert simulate_time(stats, 1000) == ['Comet', 1120]

with open('input14.txt') as file:
	stats = parse_file(file)

print simulate_time(stats, 2503)
print simulate_time_part2(stats, 2503)
