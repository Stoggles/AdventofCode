#!/usr/bin/perl

use strict;
use warnings;
use Carp::Assert;
use Digest::MD5 qw(md5_hex);

sub find_first_code {
	my ($door_id) = @_;

	my $index = 0;
	my ($hash, @password);

	while (scalar @password < 8) {
		$hash = md5_hex($door_id . $index);

		if (substr($hash, 0, 5) eq '00000') {
			push @password, substr($hash, 5, 1);
		}
		$index++;
	}

	return (join '', @password);
}

sub print_code {
	my (@code) = @_;

	my @characters = ('a' .. 'f', '0' .. '9');

	print "\r";
	foreach (@code) {
		unless ($_ eq '-') {
			print $_, ' ';
		} else {
			print @characters[rand scalar @characters], ' ';
		}
	}

	return;
}

sub find_second_code {
	my ($door_id, $silent) = @_;

	my $hash;
	my $index = 0;
	my @password = ('-','-','-','-','-','-','-','-');

	$|++ unless $silent; # disable terminal output buffering

	until ((join '', @password) =~ /[[:xdigit:]]{8}/) {
		$hash = md5_hex($door_id . $index);

		if (substr($hash, 0, 5) eq '00000' && substr($hash, 5, 1) =~ /[0-7]/ && @password[substr($hash, 5, 1)] eq '-') {
			@password[substr($hash, 5, 1)] = substr($hash, 6, 1);
			print_code(@password) unless $silent;
		}

		unless ($silent) {
			if ($index % 1000 == 0) {
				print_code(@password);
			}
		}
		$index++;
	}

	print "\n" unless $silent;
	return (join '', @password);
}

my $test1 = 'abc';
assert (find_first_code($test1) eq '18f47a30');
assert (find_second_code($test1, 1) eq '05ace8e3');

my $door_id = 'wtnhxymk';
print find_first_code($door_id) . "\n";
print find_second_code($door_id) . "\n";
