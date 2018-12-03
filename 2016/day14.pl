#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;
use Digest::MD5 qw(md5_hex);
use List::Util qw(max);

my %hash_cache;

sub is_key {
	my ($salt, $index, $part2) = @_;
	my ($hash, $magic_key);

	$hash = md5_hex($salt . $index);

	if ($part2) {
		foreach (1 .. 2016) {
			$hash = md5_hex($hash);
		}
	}

	$hash_cache{ $index } = $hash;

	if ( $hash_cache{ $index } =~ /([a-f0-9])\1{2}/ ) {
		$magic_key = $1;
	} else {
		return 0;
	}

	# ensure all the search space has been geneated
	my $max_index = max(keys %hash_cache);

	while ( $max_index < ($index + 1001) ) {
		$max_index++;

		# prune now useless hashes
		delete $hash_cache{$max_index - 1001};

		my $new_hash = md5_hex($salt . $max_index);

		if ($part2) {
			foreach (1 .. 2016) {
				$new_hash = md5_hex($new_hash);
			}
		}

		$hash_cache{ $max_index } = $new_hash;
	}

	# check the next 1000 hashs for a match;
	foreach ( ($index + 1) .. ($index + 1000) ) {
		if ( $hash_cache{ $_ } =~ /($magic_key)\1{4}/ ) {
			# print $magic_key;
			# print $hash_cache{$index};
			# print $hash_cache{$_};
			return 1;
		}
	}
	return 0;
}

sub find_keys {
	my ($salt, $part2) = @_;

	%hash_cache = ();

	my $index = 0;
	my $total_keys = 0;

	for (;;) {
		if (is_key($salt, $index, $part2)) {
			$total_keys++;
			print 'found ' . $total_keys . ' at index '. $index;

			if ($total_keys == 64) {
				return $index;
			}
		}

		$index++
	}
}

assert (find_keys('abc') == 22728);
print find_keys('ihaygndm');

assert (find_keys('abc', 1) == 22551);
print find_keys('ihaygndm', 1);
