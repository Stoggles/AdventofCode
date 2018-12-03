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

sub parse_instuction {
	my ($in_string) = @_;
	my ($count, $multiple);

	shift @{$in_string}; # consume (

	while (@{$in_string}[0] =~ /\d/) {
		$count .= shift @{$in_string};
	}

	shift @{$in_string}; # consume x

	while (@{$in_string}[0] =~ /\d/) {
		$multiple .= shift @{$in_string};
	}

	shift @{$in_string}; # consume )

	return ($count, $multiple);
}

sub deep_copy {
	my ($in_array) = @_;

	my @out_array;

	foreach (@{$in_array}) {
		push @out_array, $_;
	}

	return \@out_array;
}

sub decompress {
	my ($string, $part2) = @_;

	my @in_string = split //, $string;

	return recurse(\@in_string, $part2);
}

sub recurse {
	my ($in_string, $part2) = @_;

	my ($total, @working_string);

	while (scalar @{$in_string}) {
		if (@{$in_string}[0] eq '(') {
			my ($count, $multiple) = parse_instuction(\@{$in_string});
			my @duplicate;

			foreach (1 .. $count) {
				push @duplicate, shift @{$in_string};
			}

			if ($part2) {
				$total += recurse(deep_copy(\@duplicate), $part2) * $multiple;
			} else {
				$total += $count * $multiple
			}
		} else {
			shift @{$in_string};
			$total += 1;
		}
	}

	return $total;
}

assert (decompress('ADVENT') == 6);
assert (decompress('A(1x5)BC') == 7);
assert (decompress('(3x3)XYZ') == 9);
assert (decompress('(6x1)(1x3)A') == 6);
assert (decompress('X(8x2)(3x3)ABCY') == 18);

assert (decompress('(3x3)XYZ', 1) == 9);
assert (decompress('X(8x2)(3x3)ABCY', 1) == 20);
assert (decompress('(27x12)(20x12)(13x14)(7x10)(1x12)A', 1) == 241920);
assert (decompress('(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN', 1) == 445);

foreach (@{parse_file('input09.txt')}) {
	print decompress($_);
	print decompress($_, 1);
}
