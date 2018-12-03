#!/usr/bin/perl -l

use strict;
use warnings;

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub give_to_bot {
	my ($bots, $bot, $value) = @_;

	if ($bots->{$bot}->{low}) {
		if ($value < $bots->{$bot}->{low}) {
				$bots->{$bot}->{high} = $bots->{$bot}->{low};
				$bots->{$bot}->{low} = $value;
		} else {
			$bots->{$bot}->{high} = $value;
		}
	} else {
		$$bots{$bot} = {low => $value, high => undef};
	}

	if ($bots->{$bot}->{low} == 17 && $bots->{$bot}->{high} && $bots->{$bot}->{high} == 61) {
		print 'bot number: ' . $bot;
	}
}

sub parse_bot_instructions {
	my ($instructions, $silent) = @_;

	my %bots;
	my %outputs;

	while (@{$instructions}) {

		my $raw_instuction = shift @{$instructions};

		my @instruction = split / /, $raw_instuction;

		if ($instruction[0] eq 'value') {
			# value 19 goes to bot 20
			give_to_bot(\%bots, $instruction[5], $instruction[1]);
		} elsif ($instruction[0] eq 'bot') {
			if ($bots{$instruction[1]}->{low} && $bots{$instruction[1]}->{high}) {
				# bot 28 gives low to output 0 and high to bot 61
				if ($instruction[5] eq 'output') {
					$outputs{$instruction[6]} = $bots{$instruction[1]}->{low};
				} elsif ($instruction[5] eq 'bot') {
					give_to_bot(\%bots, $instruction[6], $bots{$instruction[1]}->{low})
				}
				if ($instruction[10] eq 'output') {
					$outputs{$instruction[11]} = $bots{$instruction[1]}->{high};
				} elsif ($instruction[10] eq 'bot') {
					give_to_bot(\%bots, $instruction[11], $bots{$instruction[1]}->{high})
				}
			} else {
				push @{$instructions}, $raw_instuction;
			}
		}
	}

	print $outputs{0} * $outputs{1} * $outputs{2} unless $silent;
}

my @test1 = ('value 5 goes to bot 2', 'bot 2 gives low to bot 1 and high to bot 0', 'value 3 goes to bot 1', 'bot 1 gives low to output 1 and high to bot 0', 'bot 0 gives low to output 2 and high to output 0', 'value 2 goes to bot 2');
parse_bot_instructions(\@test1, 1);

parse_bot_instructions(parse_file('input10.txt'));
