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

sub parse_instructions {
	my ($lines) = @_;

	my @instructions;

	foreach (@{$lines}) {
		my @instruction = split / /, $_;

		if ($instruction[0] eq 'swap' || $instruction[0] eq 'move') {
			push @instructions, [$instruction[0], $instruction[2], $instruction[5]];
		} elsif ($instruction[0] eq 'reverse') {
			push @instructions, [$instruction[0], $instruction[2], $instruction[4]];
		} elsif ($instruction[0] eq 'rotate') {
			if ($instruction[1] =~ /left|right/) {
				push @instructions, [$instruction[0], $instruction[1], $instruction[2]];
			} else {
				push @instructions, [$instruction[0], $instruction[6]];
			}
		}
	}

	return \@instructions;
}

sub reverse_segment {
	my ($string, $instruction) = @_;

	my $length = @{$instruction}[2] - @{$instruction}[1];

	my @temp = reverse splice @{$string}, @{$instruction}[1], $length + 1;

	splice @{$string}, @{$instruction}[1], 0, @temp;

	return @{$string};
}

sub move {
	my ($string, $instruction, $part2) = @_;

	my $target = @{$instruction}[1];
	my $destination = @{$instruction}[2];

	if ($part2) {
		my $temp = $target;
		$target = $destination;
		$destination = $temp;
	}

	my $temp = splice @{$string}, $target, 1 ;

	splice @{$string}, $destination, 0, $temp;

	return @{$string};
}

sub swap {
	my ($string, $instruction) = @_;

	my $index_a;
	my $index_b;

	if (@{$instruction}[1] =~ /\d/ && @{$instruction}[2] =~ /\d/) {
		$index_a = @{$instruction}[1];
		$index_b = @{$instruction}[2];
	} else {
		foreach (0 .. scalar @{$string} - 1) {
			if (@{$string}[$_] eq @{$instruction}[1]) {
				$index_a = $_;
			} elsif (@{$string}[$_] eq @{$instruction}[2]) {
				$index_b = $_;
			}
		}
	}

	my $temp = @{$string}[$index_b];
	@{$string}[$index_b] = @{$string}[$index_a];
	@{$string}[$index_a] = $temp;

	return @{$string};
}

sub rotate {
	my ($string, $instruction, $part2) = @_;

	my $p2_map = {0 => 1, 1 => 7, 2 => 2, 3 => 6, 4 => 1, 5 => 5, 6 => 0, 7 => 4};

	my $direction = @{$instruction}[1];
	my $index = @{$instruction}[2];

	if ($part2) {
		if ($direction eq 'left') {
			$direction = 'right';
		} elsif ($direction eq 'right') {
			$direction = 'left';
		}
	}

	if ($direction eq 'left') {
		for (1 .. $index) {
			push @{$string}, shift @{$string};
		}
	} elsif ($direction eq 'right') {
		for (1 .. $index) {
			unshift @{$string}, pop @{$string};
		}
	} else {
		foreach (0 .. scalar @{$string} - 1) {
			if (@{$string}[$_] eq @{$instruction}[1]) {
				$index = $_;
				last;
			}
		}

		if ($part2) {
			$index = $p2_map->{$index};
		} else {
			$index++ if $index >= 4;
			$index++;
		}

		for (1 .. $index) {
			unshift @{$string}, pop @{$string};
		}
	}

	return @{$string};
}

sub scramble {
	my ($input_string, $instructions, $part2) = @_;

	my @string = split //, $input_string;

	if ($part2) {
		@{$instructions} = reverse @{$instructions};
	}

	foreach my $instruction (@{$instructions}) {
		if (@{$instruction}[0] eq 'swap') {
			@string = swap(\@string, $instruction);
		} elsif (@{$instruction}[0] eq 'move') {
			@string = move(\@string, $instruction, $part2);
		} elsif (@{$instruction}[0] eq 'reverse') {
			@string = reverse_segment(\@string, $instruction);
		} elsif (@{$instruction}[0] eq 'rotate') {
			@string = rotate(\@string, $instruction, $part2);
		}
	}

	return join '', @string;
}

my @test = ('swap position 4 with position 0', 'swap letter d with letter b', 'reverse positions 0 through 4', 'rotate left 1 step', 'move position 1 to position 4', 'move position 3 to position 0', 'rotate based on position of letter b', 'rotate based on position of letter d');
assert (scramble('abcde', parse_instructions(\@test)) eq 'decab');

my $instructions = parse_instructions(parse_file('input21.txt'));
print scramble('abcdefgh', $instructions);
print scramble('fbgdceah', $instructions, 1);
