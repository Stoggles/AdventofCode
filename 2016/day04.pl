#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use List::MoreUtils qw(uniq);

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub parse_room {
	my ($line) = @_;

	my ($string, $sector, $checksum) = $line =~ /([a-z-]+)-(\d+)\[([a-z]{5})\]/;

	return { string => $string, sector => $sector, checksum => $checksum };
}

sub check_checksum {
	my ($details) = @_;

	my ($results, @checksum, @sorted_keys);

	foreach (split //, $details->{string}) {
			$results->{$_} += 1 unless $_ eq '-';
	}

	foreach my $count (sort {$b <=> $a} uniq values %{$results}) {
		@sorted_keys = grep { $results->{$_} eq $count } keys %{$results};

		push @checksum, sort @sorted_keys;
	}

	return $details->{checksum} eq join('',@checksum[0 .. 4]);
}

sub decrypt {
	my ($shift, $string) = @_;

	$shift = $shift % 26;

	my $az = join '', ('a'..'z');
	my $cypher = substr($az, $shift, 26 - $shift) . substr($az, 0, $shift);

	$az .= '-';
	$cypher .= ' ';

	return eval "\$string =~ tr/$az/$cypher/r";
}

my $test1 = 'aaaaa-bbb-z-y-x-123[abxyz]';
my $test2 = 'a-b-c-d-e-f-g-h-987[abcde]';
my $test3 = 'not-a-real-room-404[oarel]';
my $test4 = 'totally-real-room-200[decoy]';
assert (check_checksum(parse_room($test1)));
assert (check_checksum(parse_room($test1)));
assert (check_checksum(parse_room($test1)));
assert (check_checksum(parse_room($test4)) == 0);

my ($details, $total);

foreach (@{parse_file('input04.txt')}) {
	$details = parse_room($_);
	if (check_checksum($details)) {
		$total += $details->{sector};
		print $details->{sector}, ' ',decrypt($details->{sector}, $details->{string});
	}
}

print $total;
