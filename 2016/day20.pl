#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use List::Util qw(max);

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	my @ranges = sort { $a->{low} <=> $b->{low} } map { /(\d+)-(\d+)/; {low => $1, high => $2} } @lines;

	return \@ranges;
}


sub restrict_ips {
	my ($lines, $part2) = @_;

	my $low = 0;
	my $high = 4294967295;

	my $check = 0;
	my $count = 0;

	foreach (@{$lines}) {
		if ($_->{low} <= ($low + 1) && $_->{high} >= ($low + 1)) {
			$low = $_->{high};
		}

		next if $_->{high} < $check;
		if ($check < $_->{low}) {
			$count += $_->{low} - $check;
		}
		$check = $_->{high} + 1;
	}

	if ($part2) {
		return $count += $high + 1 - $check;
	} else {
		return $low + 1;
	}
}

my @test1 = [{low => '0', high => '2'}, {low => '4', high => '7'}, {high => '8', low => '5'}];
assert (restrict_ips(@test1) == 3);

my $ips = parse_file('input20.txt');
print restrict_ips($ips);
print restrict_ips($ips, 1);
