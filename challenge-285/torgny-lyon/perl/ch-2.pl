#!/usr/bin/perl

use v5.40;

use Test::More tests => 3;

sub make_change {
    my @coins = (1, 5, 10, 25, 50);
    return 0 if (my $n = shift) < 0;
    return 1 if (my $i = shift // $#coins) == 0;
    return make_change($n, $i - 1) + make_change($n - $coins[$i], $i);
}

is(make_change(9), 2);
is(make_change(15), 6);
is(make_change(100), 292);
