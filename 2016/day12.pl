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

sub execute {
	my ($instructions, $part2) = @_;

	my $prog_counter = 0;
	my $registers = {a => 0, b => 0, c => 0, d => 0};

	if ($part2) {
		$registers->{c} = 1;
	}

	while ($prog_counter < scalar @{$instructions}) {
		my @instruction = split / /, @{$instructions}[$prog_counter];

		if ($instruction[0] eq 'cpy') {
			if ($instruction[1] =~ /\d+/) {
				$registers->{$instruction[2]} = $instruction[1];
			} else {
				$registers->{$instruction[2]} = $registers->{$instruction[1]};
			}
		} elsif ($instruction[0] eq 'inc') {
			$registers->{$instruction[1]}++;
		} elsif ($instruction[0] eq 'dec') {
			$registers->{$instruction[1]}--;
		} elsif ($instruction[0] eq 'jnz') {
			if ($instruction[1] =~ /[abcd]/ && $registers->{$instruction[1]} || $instruction[1] =~ /\d+/ && $instruction[1] > 0) {
				$prog_counter += $instruction[2];
				next;
			}
		}
		$prog_counter++;
	}

	use Data::Dumper;
	print Dumper $registers;

	return;
}

my @test1 = ('cpy 41 a', 'inc a', 'inc a', 'dec a', 'jnz a 2', 'dec a');
execute(\@test1);

execute(parse_file('input12.txt'));
execute(parse_file('input12.txt'), 1);
