#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub generate_data {
	my ($a, $length) = @_;

	while (length $a < $length) {
		my $b = reverse $a;
		$b =~ tr/10/01/;
		$a = $a . '0' . $b;
	}

	return substr $a, 0, $length;
}

sub generate_checksum {
	my ($data) = @_;

	my $checksum = '';

	my $length = length $data;

	for (my $i = 0; $i < $length; $i+=2) {
		if (substr($data, $i, 1) eq substr($data, $i+1, 1)) {
			$checksum .= '1';
		} else {
			$checksum .= '0';
		}
	}

	(length $checksum) % 2 == 0 ? return generate_checksum($checksum) : return $checksum;
}

assert (generate_data('1', 3) eq '100');
assert (generate_data('0', 3) eq '001');
assert (generate_data('11111', 11) eq '11111000000');
assert (generate_data('111100001010', 25) eq '1111000010100101011110000');
assert (generate_data('10000', 20) eq '10000011110010000111');

assert (generate_checksum('110010110100') eq '100');

assert (generate_checksum(generate_data('10000', 20)) eq '01100');

print (generate_checksum(generate_data('00101000101111010', 272)));
print (generate_checksum(generate_data('00101000101111010', 35651584)));
