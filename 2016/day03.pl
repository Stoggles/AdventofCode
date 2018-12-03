#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub is_triangle {
	my (@sides) = @_;
	return ($sides[0] + $sides[1] > $sides[2]);
}

sub count_triangles {
	my ($triangles, $part2) = @_;

	my @sides;
	my $count = 0;

	unless ($part2) {
		foreach my $triangle (@{$triangles}) {
			@sides = sort {$a <=> $b} split ' ', $triangle;
			$count++ if is_triangle(@sides);
		}
	} else {
		while (@{$triangles}) {
			my @triplets;

			foreach (0 .. 2) {
				push @triplets, split ' ', shift @{$triangles};
			}

			foreach (0 .. 2) {
				my @sides = sort {$a <=> $b} ($triplets[0 + $_], $triplets[3 + $_], $triplets[6 + $_]);
				$count++ if is_triangle(@sides);
			}
		}
	}

	return $count;
}

my $test = ['5 10 25'];
assert(count_triangles($test) == 0);

my $triangles = parse_file('input03.txt');
print count_triangles($triangles);
print count_triangles($triangles, 1);
