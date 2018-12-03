#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use List::Util qw(max min);

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub error_correct {
	my ($input, $part2) = @_;

	my @corrected_string;

	foreach my $index (0 .. (length @{$input}[0])-1) {
		my %results;

		foreach (0 .. (scalar @{$input})-1) {
			$results{substr(@{$input}[$_], $index, 1)} += 1;
		}

		my @sorted = sort {$results{$b} <=> $results{$a}} keys %results;

		defined $part2 ? push @corrected_string, $sorted[-1] : push @corrected_string, $sorted[0];
	}

	return join('', @corrected_string);
}

my @test1 = qw/eedadn drvtee eandsr raavrd atevrs tsrnev sdttsa rasrtv nssdts ntnada svetve tesnvt vntsnd vrdear dvrsen enarar/;
assert (error_correct(\@test1) eq 'easter');
assert (error_correct(\@test1, 1) eq 'advent');

my $data = parse_file('input06.txt');
print error_correct($data);
print error_correct($data, 1);
