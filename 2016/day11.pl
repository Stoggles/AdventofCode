#!/usr/bin/perl -l

use strict;
use warnings;
use Carp::Assert;

sub generate_moves {
	my ($current_state) = @_;

	my ($direction, $length, @available_moves, @available_moves_up, @available_moves_down);

	my $current_position = $current_state->{state};
	my $elevator_position = $current_state->{floor};
	my $depth = $current_state->{depth} += 1;

	$direction = 1;
	$length = scalar @{$current_position};
	unless ($elevator_position + $direction < 1 || $elevator_position + $direction > 4) {
		for (my $i = 0; $i < $length; $i++) {
			if (@{$current_position}[$i] == $elevator_position) {
				push @available_moves_up, {
					state => [ @{$current_position}[0 .. $i - 1],@{$current_position}[$i]+$direction,@{$current_position}[$i + 1 .. $length - 1] ],
					floor => $elevator_position + $direction,
					depth => $depth
				};
			}
		}

		foreach (@available_moves_up) {
			$current_position = $_->{state};

			for (my $i = 0; $i < $length; $i++) {
				if (@{$current_position}[$i] == $elevator_position) {
					push @available_moves, {
						state => [ @{$current_position}[0 .. $i - 1],@{$current_position}[$i]+$direction,@{$current_position}[$i + 1 .. $length - 1] ],
						floor => $elevator_position + $direction,
						depth => $depth
					};
				}
			}
		}

		push @available_moves, @available_moves_up;
	}

	$direction = -1;
	$current_position = $current_state->{state};
	unless ($elevator_position + $direction < 1 || $elevator_position + $direction > 4) {
		for (my $i = 0; $i < $length; $i++) {
			if (@{$current_position}[$i] == $elevator_position) {
				push @available_moves_down, {
					state => [ @{$current_position}[0 .. $i - 1],@{$current_position}[$i]+$direction,@{$current_position}[$i + 1 .. $length - 1] ],
					floor => $elevator_position + $direction,
					depth => $depth
				};
			}
		}

		foreach (@available_moves_down) {
			$current_position = $_->{state};

			for (my $i = 0; $i < $length; $i++) {
				if (@{$current_position}[$i] == $elevator_position) {
					push @available_moves, {
						state => [ @{$current_position}[0 .. $i - 1],@{$current_position}[$i]+$direction,@{$current_position}[$i + 1 .. $length - 1] ],
						floor => $elevator_position + $direction,
						depth => $depth
					};
				}
			}
		}

		push @available_moves, @available_moves_down;
	}

	my @valid_moves;

	OUTER: foreach (@available_moves) {
		my $move = $_->{state};

		my @pairs;

		for (my $i = 0; $i < scalar @{$move} - 1; $i += 2) {
			push @pairs, [ @{$move}[$i], @{$move}[$i+1] ];
		}

		foreach my $p1 (0 .. scalar @pairs - 1) {
			foreach my $p2 (0 .. scalar @pairs - 1) {
				next if ($p1 eq $p2);

				if ( ( $pairs[$p1]->[1] == $pairs[$p2]->[0] && $pairs[$p1]->[0] != $pairs[$p1]->[1] )
					||
					( $pairs[$p2]->[1] == $pairs[$p1]->[0] && $pairs[$p2]->[0] != $pairs[$p2]->[1] ) ) {
					next OUTER;
				}
			}
		}

		push @valid_moves, $_;
	}

	return @valid_moves;
}

sub find_route {
	my ($start_position) = @_;

	my ($start_state, $current_state, @result, @previous_positions);

	$start_state = {
		state => @{$start_position},
		floor => 1,
		depth => 0,
	};

	# fuck perls array references
	foreach (@{@{$start_position}[0]}) {
		push @result, 4;
	}

	my @valid_moves = generate_moves($start_state);

	while (scalar @valid_moves) {

		$current_state = shift @valid_moves;

		my @pairs;

		for (my $i = 0; $i < scalar @{$current_state->{state}} - 1; $i += 2) {
			push @pairs, [ $current_state->{state}[$i], $current_state->{state}[$i+1] ];
		}

		my $current_position;
		$current_position .= join '', @{$_} foreach (sort {$a->[0] <=> $b->[0] || $a->[1] <=> $b->[1]} @pairs);
		$current_position .= $current_state->{floor};

		if (grep $current_position eq $_, @previous_positions) {
			next;
		} else {
			push @previous_positions, $current_position;
		}

		if (($current_state->{state} ~~ @result)) {
			return $current_state->{depth};
		} else {
			push @valid_moves, generate_moves($current_state);
		}
	}

	print 'out of moves';
}

my @test = [2, 1, 3, 1];
assert (find_route(\@test) == 11);

my @part_1 = [1, 1, 1, 1, 2, 2, 2, 2, 2, 3];
print find_route(\@part_1);

my @part_2 = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3];
print find_route(\@part_2);
