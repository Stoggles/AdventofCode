#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use Storable qw(dclone);

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub execute {
	my ($input, $registers) = @_;

	$registers = {a => 0, b => 0, c => 0, d => 0} unless $registers;

	my $prog_counter = 0;
	my $instructions = $input;
	while ($prog_counter < scalar @{$instructions}) {
		my @instruction = split / /, @{$instructions}[$prog_counter];
		if ($instruction[0] eq 'inc' && defined($registers->{$instruction[1]})) {
			$registers->{$instruction[1]}++;
		} elsif ($instruction[0] eq 'dec' && defined($registers->{$instruction[1]})) {
			$registers->{$instruction[1]}--;
		} elsif ($instruction[0] eq 'tgl') {
			my $offset;
			if ($registers->{$instruction[1]}) {
				$offset = $registers->{$instruction[1]};
			} else {
				$offset = $instruction[1];
			}
			unless ($prog_counter + $offset >= scalar @{$instructions} || $prog_counter + $offset <= 0) {
				my @instruction_to_modify = split / /, @{$instructions}[$prog_counter + $offset];
				if (scalar @instruction_to_modify == 2) {
					if ($instruction_to_modify[0] eq 'inc') {
						$instruction_to_modify[0] = 'dec';
					} else {
						$instruction_to_modify[0] = 'inc';
					}
				} elsif (scalar @instruction_to_modify == 3) {
					if ($instruction_to_modify[0] eq 'jnz') {
						$instruction_to_modify[0] = 'cpy';
					} else {
						$instruction_to_modify[0] = 'jnz';
					}
				}
				@{$instructions}[$prog_counter + $offset] = join ' ', @instruction_to_modify;
			}
		} elsif ($instruction[0] eq 'cpy') {
			if ($registers->{$instruction[1]}) {
				$registers->{$instruction[2]} = $registers->{$instruction[1]};
			} else {
				$registers->{$instruction[2]} = $instruction[1];
			}
		} elsif ($instruction[0] eq 'jnz') {
			if (($instruction[1] =~ /[abcd]/ && $instruction[2] =~ /\d+/ && $registers->{$instruction[1]}) || ($instruction[1] =~ /\d+/ && $instruction[1] > 0)) {
				my $offset;
				if ($registers->{$instruction[2]}) {
					$offset = $registers->{$instruction[2]};
				} else {
					$offset = $instruction[2];
				}
				if ($offset == -5) {
					# 'optimisation'
					my $arg1 = (split / /, @{$instructions}[$prog_counter - 1])[1];
					my $arg2 = (split / /, @{$instructions}[$prog_counter - 5])[1];
					my $dest = (split / /, @{$instructions}[$prog_counter - 4])[1];

					$arg1 = $registers->{$arg1} if $registers->{$arg1};
					$arg2 = $registers->{$arg2} if $registers->{$arg2};

					$registers->{$dest} += ($arg1 * $arg2);
					$registers->{c} = 0;
					$registers->{d} = 0;
				} else {
					$prog_counter += $offset;
				}
				next;
			}
		}
		$prog_counter++;
	}

	print sprintf('a:%d b:%d c:%d d:%d', $registers->{a}, $registers->{b}, $registers->{c}, $registers->{d});

	return $registers;
}
my @test1 = ('cpy 41 a', 'inc a', 'inc a', 'dec a', 'jnz a 2', 'dec a');
my @test2 = ('cpy 2 a', 'tgl a', 'tgl a', 'tgl a', 'cpy 1 a', 'dec a', 'dec a');
assert (execute(\@test1)->{a} == 42);
assert (execute(\@test2)->{a} == 3);

my $instructions = parse_file('input23.txt');

execute(dclone($instructions), {a => 7, b => 0, c => 0, d => 0});
execute(dclone($instructions), {a => 12, b => 0, c => 0, d => 0});

