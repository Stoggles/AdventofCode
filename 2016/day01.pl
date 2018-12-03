#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	my $line = <$fh>;

	$line =~ s/\R//g;

	my @instructions = split /, /, $line;

	close $fh;

	return \@instructions;
}

sub do_instructions {
	my ($instructions, $part2) = @_;

	my $coords = {x => 0, y => 0};

	my $heading = {x => 0, y => 1};

	my @history;

	OUTER: foreach my $instruction (@$instructions) {
		my ($turn, $distance) = $instruction =~ /([L|R])(\d+)/;

		if ($turn eq 'L') {
			$heading = {x => -$heading->{y}, y => $heading->{x}}
		} elsif ($turn eq 'R') {
			$heading = {x => $heading->{y}, y => -$heading->{x}}
		}

		INNER: foreach (1 .. $distance) {
			push @history, { %$coords };

  			$coords->{x} += $heading->{x};
			$coords->{y} += $heading->{y};

			if ($part2) {
				foreach my $previous_location (@history) {
					if ($coords->{x} == $previous_location->{x} && $coords->{y} == $previous_location->{y}) {
						last OUTER;
					}
				}
			}
		}
	}
	return (abs $coords->{x}) + (abs $coords->{y});
}

my $test1 = ['R2', 'L3'];
my $test2 = ['R2', 'R2', 'R2'];
my $test3 = ['R5', 'L5', 'R5', 'R3'];
my $test4 = ['R8', 'R4', 'R4', 'R8'];

assert(do_instructions($test1) == 5);
assert(do_instructions($test2) == 2);
assert(do_instructions($test3) == 12);
assert(do_instructions($test4, 1) == 4);

my $instructions = parse_file('input01.txt');

print do_instructions($instructions);
print do_instructions($instructions, 1);
