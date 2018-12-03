#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use Digest::MD5 qw(md5_hex);

sub generate_row {
	my ($previous_row) = @_;

	my @previous_row = split //, $previous_row;
	my $next_row = '';

	foreach (0 .. scalar @previous_row - 1) {
		if ($_ == 0) {
			if ($previous_row[$_+1] eq '^') {
				$next_row .= '^';
				next;
			}
		} elsif ($_ == scalar @previous_row - 1) {
			if ($previous_row[$_-1] eq '^') {
				$next_row .= '^';
				next;
			}
		} elsif (
			($previous_row[$_-1] eq '^') && ($previous_row[$_] eq '^') && ($previous_row[$_+1] ne '^') ||
			($previous_row[$_-1] ne '^') && ($previous_row[$_] eq '^') && ($previous_row[$_+1] eq '^') ||
			($previous_row[$_-1] eq '^') && ($previous_row[$_] ne '^') && ($previous_row[$_+1] ne '^') ||
			($previous_row[$_-1] ne '^') && ($previous_row[$_] ne '^') && ($previous_row[$_+1] eq '^')
		) {
			$next_row .= '^';
			next;
		}
		$next_row .= '.';
	}

	return $next_row;
}

sub count_safe_spaces {
	my ($row, $rows) = @_;

	my $safe_spaces = ($row =~ tr/.//);

	foreach (2 .. $rows) {
		$row = generate_row($row);
		$safe_spaces += ($row =~ tr/.//);
	}

	return $safe_spaces;
}

assert (count_safe_spaces('..^^.', 3) == 6);
assert (count_safe_spaces('.^^.^.^^^^', 10) == 38);

print count_safe_spaces('.^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^.', 40);
print count_safe_spaces('.^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^.', 400000);
