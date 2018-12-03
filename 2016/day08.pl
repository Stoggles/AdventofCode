#!/usr/bin/perl

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

sub rotate {
	my ($pixels, $distance) = @_;

	my @updated_pixels;

	my $length = scalar @{$pixels};

	push @updated_pixels, @{$pixels}[$length-$distance .. $length-1], @{$pixels}[0 .. $length-1-$distance];

	return \@updated_pixels;
}

sub update_screen {
	my ($instructions, $display_x, $display_y, $print) = @_;

	my @display = map [('.') x $display_x], 0 .. $display_y - 1;

	foreach (@{$instructions}) {
		my @instruction = split / /, $_;

		if ($instruction[0] eq 'rect') {
			$instruction[1] =~ /(\d+)x(\d+)/;

			foreach my $x (0 .. $1-1) {
				foreach my $y (0 .. $2-1) {
					$display[$y][$x] = '#';
				}
			}
		} elsif ($instruction[0] eq 'rotate') {
			$instruction[2] =~ /[x|y]=(\d+)/;
			my @pixels;

			if ($instruction[1] eq 'column') {
				foreach (0 .. $display_y -1) {
					push @pixels, $display[$_][$1];
				}

				my $new_pixels = rotate(\@pixels, $instruction[4]);

				foreach (0 .. $display_y -1) {
					$display[$_][$1] = @{$new_pixels}[$_];
				}
			} elsif ($instruction[1] eq 'row') {
				foreach (0 .. $display_x -1) {
					push @pixels, $display[$1][$_];
				}

				my $new_pixels = rotate(\@pixels, $instruction[4]);

				foreach (0 .. $display_x -1) {
					$display[$1][$_] = @{$new_pixels}[$_];
				}
			}
		}
	}

	if ($print) {
		foreach my $x (0 .. $#display) {
			foreach my $y (0 .. $#{$display[$x]}) {
				print $display[$x][$y];
			}
			print "\n";
		}
	}

	return @display;
}

sub sum_lit_pixels {
	my (@display) = @_;

	my $total = 0;

	foreach my $x (0 .. $#display) {
		foreach my $y (0 .. $#{$display[$x]}) {
			$total += 1 if $display[$x][$y] eq '#';
		}
	}

	return $total;
}

my @test1 = ('rect 3x2', 'rotate column x=1 by 1', 'rotate row y=0 by 4', 'rotate column x=1 by 1');
assert (sum_lit_pixels(update_screen(\@test1, 7, 3)) == 6);

my $instructions = parse_file('input08.txt');
print sum_lit_pixels(update_screen($instructions, 50, 6, 1)),"\n";
