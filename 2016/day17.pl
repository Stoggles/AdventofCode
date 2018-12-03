#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use Digest::MD5 qw(md5_hex);

sub generate_moves {
	my ($passcode, $path) = @_;

	my $hash = md5_hex($passcode . $path);

	my @valid_moves;

	if ($hash =~ /^[b-f].*$/) {
		push @valid_moves, $path . 'U';
	}

	if ($hash =~ /^.{1}[b-f].*$/) {
		push @valid_moves, $path . 'D';
	}

	if ($hash =~ /^.{2}[b-f].*$/) {
		push @valid_moves, $path . 'L';
	}

	if ($hash =~ /^.{3}[b-f].*$/) {
		push @valid_moves, $path . 'R';
	}

	return @valid_moves;
}

sub find_route {
	my ($passcode, $part2) = @_;

	my @valid_moves = generate_moves($passcode, '');

	my $maximum_path_length;

	while (scalar @valid_moves) {
		my $path = shift @valid_moves;

		my $pos_x = ($path =~ tr/R//) - ($path =~ tr/L//);
		my $pos_y = ($path =~ tr/D//) - ($path =~ tr/U//);

		if ($pos_y > 3 || $pos_y < 0 || $pos_x > 3 || $pos_x < 0) {
			# out of bounds
			next;
		}

		if ($pos_y == 3 && $pos_x == 3) {
			if ($part2) {
				$maximum_path_length = length $path;
				next;
			}

			return $path;
		}

		push @valid_moves, generate_moves($passcode, $path);
	}

	return $maximum_path_length;
}

assert (find_route('ihgpwlah') eq 'DDRRRD');
assert (find_route('kglvqrro') eq 'DDUDRLRRUDRD');
assert (find_route('ulqzkmiv') eq 'DRURDRUDDLLDLUURRDULRLDUUDDDRR');

print find_route('pxxbnzuo');

assert (find_route('ihgpwlah', 1) == 370);
assert (find_route('kglvqrro', 1) == 492);
assert (find_route('ulqzkmiv', 1) == 830);

print find_route('pxxbnzuo', 1);
