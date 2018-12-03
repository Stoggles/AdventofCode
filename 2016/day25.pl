#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use List::Util qw(sum);
use POSIX qw (floor);
use Storable qw(dclone);

sub parse_file {
	my ($filename) = @_;

	open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";

	chomp(my @lines = <$fh>);

	close $fh;

	return \@lines;
}

sub execute {
	my ($input, $a) = @_;

	my $registers = {a => $a, b => 0, c => 0, d => 0};

	my @out;

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
				$prog_counter += $offset;
				next;
			}
		} elsif ($instruction[0] eq 'out') {
			if (defined($registers->{$instruction[1]})) {
				push @out, $registers->{$instruction[1]};
			} else {
				push @out, $instruction[1];
			}
		}
		$prog_counter++;

		last if scalar(@out) > 50;
	}

	print sprintf('a:%d b:%d c:%d d:%d', $registers->{a}, $registers->{b}, $registers->{c}, $registers->{d});

	return 0 unless ($out[0] == 0);

	my $prev = 1;
	foreach (@out) {
		return 0 if $prev == $_;
		$prev = $_;
	}

	return 1;
}

my $instructions = parse_file('input25.txt');

my $a = 1;
until (execute(dclone($instructions), $a)) {
	$a += 1;
}

print $a;
