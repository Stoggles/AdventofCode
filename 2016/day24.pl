#!/usr/bin/perl -l

use strict;
use warnings;
use Algorithm::Permute;
use Carp::Assert;

my $CACHE;

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub make_grid {
	my ($data) = @_;

	my @grid;

	foreach my $line (@{$data}) {
		for (my $i = 0; $i < length($line); $i++) {
			$grid[$i] = [] unless $grid[$i];
			push @{$grid[$i]}, substr($line, $i, 1);
		}
	}

	return \@grid;
}

sub get_routes {
	my ($grid, $part2) = @_;
	my (@targets, @permutation, @routes);

	for (my $x = 0; $x < scalar(@{$grid}); $x++) {
		for (my $y = 0; $y < scalar(@{$grid->[$x]}); $y++) {
			if ($grid->[$x]->[$y] =~ /(\d+)/) {
				push @targets, $1;
			}
		}
	}

	my $iterator = Algorithm::Permute->new(\@targets, scalar @targets);
	while (@permutation = $iterator->next()) {
		next if $permutation[0] != 0;
		push @permutation, 0 if $part2;
		push @routes, join('', @permutation);
	}

	return \@routes;
}

sub find {
	my ($grid, $point) = @_;

	for (my $x = 0; $x < scalar(@{$grid}); $x++) {
		for (my $y = 0; $y < scalar(@{$grid->[$x]}); $y++) {
			if ($grid->[$x]->[$y] eq $point) {
				return { x => $x, y => $y };
			}
		}
	}

	die('Unable to find point');
}

sub generate_moves {
	my ($grid, $pos, $depth) = @_;

	my @moves;

	for (my $dx = -1; $dx <= 1; $dx++) {
		for (my $dy = -1; $dy <= 1; $dy++) {
			next unless (abs($dx) + abs($dy) == 1);
			next if ($pos->{x} + $dx < 0 || $pos->{y} + $dy < 0);
			next if ($pos->{x} + $dx >= scalar(@{$grid}) || $pos->{y} + $dy >= scalar(@{$grid->[$pos->{x} + $dx]}));
			next if $grid->[$pos->{x} + $dx]->[$pos->{y} + $dy] eq '#';
			push @moves, { x => $pos->{x} + $dx, y => $pos->{y} + $dy, depth => $depth };
		}
	}

	return @moves;
}

sub find_route {
	my ($grid, $start, $end) = @_;

	my @previous_positions;

	my $startPos = find($grid, $start);
	my $endPos = find($grid, $end);
	my $key = join(',', $startPos->{x}, $startPos->{y}, $endPos->{x}, $endPos->{y});

	return $CACHE->{$key} if $CACHE->{$key};

	my @valid_moves = generate_moves($grid, $startPos, 1);

	while (scalar @valid_moves) {
		my $pos = shift @valid_moves;

		my $current_position = join(',', $pos->{x}, $pos->{y});

		if ($current_position eq join(',', $endPos->{x}, $endPos->{y})) {
			$CACHE->{$key} = $pos->{depth};
			return $pos->{depth};
		}

		if (grep $current_position eq $_, @previous_positions) {
			next; # been here before
		} else {
			push @previous_positions, $current_position;
		}

		push @valid_moves, generate_moves($grid, $pos, $pos->{depth} += 1);
	}

	die('out of moves');
}

sub find_shortest_path {
	my ($grid, $permutations) = @_;

	undef $CACHE;

	my $lowest_steps = 9999999;

	OUTER: foreach my $permutation (@{$permutations}) {
		my $total_steps = 0;
		for (my $i = 0; $i < length($permutation) - 1; $i++) {
			next OUTER if ($total_steps > $lowest_steps);
			$total_steps += find_route($grid, split('', substr($permutation, $i, 2)));
		}
		$lowest_steps = $total_steps if ($lowest_steps > $total_steps);
	}

	return $lowest_steps;
}

my @test_data = ('###########', '#0.1.....2#', '#.#######.#', '#4.......3#', '###########');
my $test_grid = make_grid(\@test_data);
my $test_routes = get_routes($test_grid);
assert (find_shortest_path($test_grid, $test_routes) == 14);

my $grid = make_grid(parse_file('input24.txt'));
print find_shortest_path($grid, get_routes($grid));
print find_shortest_path($grid, get_routes($grid, 1));
