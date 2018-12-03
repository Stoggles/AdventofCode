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

sub has_abba {
	my ($strings) = @_;

	foreach my $string (@{$strings}) {
		if ($string =~ /([a-z])(?!\1)([a-z])\2\1/) {
			return 1;
		}
	}
	return 0;
}

sub supports_tls {
	my ($ip) = @_;

	my @supernet = split /\[[a-z]+\]/, $ip;
	my @hypernet = split /[a-z]+\[|\][a-z]+\[?/, $ip;

	return has_abba(\@supernet) && !has_abba(\@hypernet);
}

sub supports_ssl {
	my ($ip) = @_;

	my @supernet = split /\[[a-z]+\]/, $ip;
	my @hypernet = split /[a-z]+\[|\][a-z]+\[?/, $ip;

	my ($super, $hyper);

	foreach $super (@supernet) {
		while ($super =~ /([a-z])(?=((?!\1)[a-z])\1)/g) {
			foreach $hyper (@hypernet) {
				if (eval "\$hyper =~ /$2$1$2/") {
					return 1;
				}
			}
		}
	}
	return 0;
}

assert (supports_tls('abba[mnop]qrst') == 1);
assert (supports_tls('abcd[bddb]xyyx') == 0);
assert (supports_tls('aaaa[qwer]tyui') == 0);
assert (supports_tls('ioxxoj[asdfgh]zxcvbn') == 1);

assert (supports_ssl('aba[bab]xyz') == 1);
assert (supports_ssl('xyx[xyx]xyx') == 0);
assert (supports_ssl('aaa[kek]eke') == 1);
assert (supports_ssl('zazbz[bzb]cdb') == 1);

my ($total_tls, $total_ssl);

foreach (@{parse_file('input07.txt')}) {
	$total_tls += supports_tls($_);
	$total_ssl += supports_ssl($_);
}

print $total_tls, ', ', $total_ssl;
