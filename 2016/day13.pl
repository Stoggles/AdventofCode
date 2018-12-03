#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub generate_moves {
	my ($position, $depth, $magic_number) = @_;

	my @valid_moves;

	my $x = @{$position}[0];
	my $y = @{$position}[1];

	my ($a, $b, $binary);

	for my $y_step (-1 .. 1) {
		for my $x_step (-1 .. 1) {
			next if ($x_step != 0 && $y_step != 0);	# can't move diagonally
			$a = $x + $x_step;
			$b = $y + $y_step;
			next if ($a < 0 || $b < 0); # don't step off the grid
			$binary = sprintf '%b', $a*$a + 3*$a + 2*$a*$b + $b + $b*$b + $magic_number;
			push @valid_moves, [ $a, $b, $depth + 1 ] if ($binary =~ tr/1//) % 2 == 0;
		}
	}

	return @valid_moves;
}

sub find_route {
	my ($objective, $magic_number, $part2) = @_;

	my @start = [1,1];
	my @previous_positions;

	my @valid_moves = generate_moves(@start, 0, $magic_number);

	while (scalar @valid_moves) {
		my @position = shift @valid_moves;

		# fuuuuuuck perl array references
		my $depth = pop @{$position[0]};

		my $current_position = join ',', @{$position[0]};

		if ($part2 && $depth > 50) {
			return scalar @previous_positions;
		} elsif ($current_position eq $objective) {
			return $depth;
		}

		if (grep $current_position eq $_, @previous_positions) {
			next;
		} else {
			push @previous_positions, $current_position;
		}

		push @valid_moves, generate_moves(@position, $depth, $magic_number);
	}

	print 'out of moves';
}

assert (find_route('7,4', 10) == 11);

print find_route('31,39', 1364);
print find_route('31,39', 1364, 1);
