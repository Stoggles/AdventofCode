#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use List::Util qw(max min);

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub find_keys {
	my ($instructions, $part2) = @_;

	my (@combination, @key_pad, $current_position, $new_position);

	unless ($part2) {
		@key_pad = ([1,2,3],[4,5,6],[7,8,9]);
		$current_position = { x => 1, y => 1};
	} else {
		@key_pad = ([undef,undef,1,undef,undef],[undef,2,3,4,undef],[5,6,7,8,9],[undef,'A','B','C',undef],[undef,undef,'D',undef,undef]);
		$current_position = { x => 0, y => 2};
	}

	foreach my $instruction (@{$instructions}) {
		foreach (split //, $instruction) {
			if ($_ eq 'U') {
				$new_position = {x => $current_position->{x}, y => $current_position->{y}-1}
			} elsif ($_ eq 'D') {
				$new_position = {x => $current_position->{x}, y => $current_position->{y}+1}
			} elsif ($_ eq 'L') {
				$new_position = {x => $current_position->{x}-1, y => $current_position->{y}}
			} elsif ($_ eq 'R') {
				$new_position = {x => $current_position->{x}+1, y => $current_position->{y}}
			}

			$new_position->{x} = max(min($new_position->{x}, scalar @key_pad - 1), 0);
			$new_position->{y} = max(min($new_position->{y}, scalar @key_pad - 1), 0);

			if ($key_pad[$new_position->{y}][$new_position->{x}]) {
				$current_position = { x => $new_position->{x}, y => $new_position->{y} };
			}
		}

		push @combination, $key_pad[$current_position->{y}][$current_position->{x}];
	}

	return join('', @combination);
}

my $test = ['ULL','RRDDD','LURDL','UUUUD'];
assert(find_keys($test) eq '1985');
assert(find_keys($test, 1) eq '5DB3');

my $instructions = parse_file('input02.txt');
print find_keys($instructions);
print find_keys($instructions, 1);
