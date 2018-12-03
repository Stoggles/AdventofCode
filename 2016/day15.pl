#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub find_time {
	my ($discs) = @_;

	my $time = 0;

	OUTER: for (;;) {
		INNER: foreach my $i (0 .. scalar @{$discs} - 1) {
			unless (($time + ($i + 1) + @{@{$discs}[$i]}[1]) % @{@{$discs}[$i]}[0] == 0) {
				$time++;
				next OUTER;
			}
		}
		return $time;
	}
}

my @test = ([5,4], [2,1]);
assert (find_time(\@test) == 5);

my @data_part1 = ([13,11], [5,0], [17,11], [3,0], [7,2], [19,17]);
my @data_part2 = ([13,11], [5,0], [17,11], [3,0], [7,2], [19,17], [11,0]);
print find_time(\@data_part1);
print find_time(\@data_part2);
