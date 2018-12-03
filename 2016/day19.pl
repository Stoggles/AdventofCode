#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub white_elephant {
	my ($count) = @_;

	my @elves = (1 .. $count);

	while (scalar @elves > 1) {
		push @elves, shift @elves; # move the first elf to the end
		shift @elves; # eliminate the next elf
	}

	return $elves[0]; # this is only elf left
}

sub white_elephant_2 {
	my ($count) = @_;

	my @left = (1 .. $count / 2);
	my @right = ($count / 2 + 1 .. $count);

	while (scalar @left) {
		shift @right; # this elf is eliminated
		push @left, shift @right if scalar @left == scalar @right; # rebalance the lists if left isn't long enough
		push @right, shift @left; # move the elf who acted to the end of the right side
	}

	return $right[0]; # this is only elf left
}

assert (white_elephant(5) == 3);

print white_elephant(3012210);

assert (white_elephant_2(5) == 2);

print white_elephant_2(3012210);
