#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	my @grid;

	foreach my $line (@lines) {
		if ($line =~ m/.*x(\d+)-y(\d+)\W+(\d+)T\W+(\d+)T\W+(\d+)T/) {
			$grid[$2][$1] = { size => $3, used => $4, avail => $5 };
		}
	}

	return \@grid;
}

sub count_pairs {
	my ($grid) = @_;

	my $xSize = scalar @{$grid};
	my $ySize = scalar @{@{$grid}[0]};
	my $pairs = 0;

	use Data::Dumper;

	foreach my $row (@{$grid}) {
		foreach my $cell (@{$row}) {
			next if ($cell->{used} == 0);
			foreach my $candidateRow (@{$grid}) {
				foreach my $candidateCell (@{$candidateRow}) {
					next if ($cell eq $candidateCell);
 					$pairs++ if ($cell->{used} <= $candidateCell->{avail});
 				}
 			}
 		}
	}

	print $pairs;

	return;
}

sub pretty_print {
	my ($grid) = @_;

	my $line;

	foreach my $row (@{$grid}) {
		foreach my $cell (@{$row}) {
			if ($cell->{used} == 0) {
				$line .= '0';
			} elsif ($cell->{used} < 92) {
				$line .= '.';
			} else {
				$line .= '|';
			}
		}
		print $line;
		undef $line;
	}

	return;
}

my $grid = parse_file('input22.txt');

count_pairs($grid);
pretty_print($grid);
