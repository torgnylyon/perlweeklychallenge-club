#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature qw{say state signatures };
no warnings qw{experimental};

use List::Util qw{ uniq };

my @arr;
push @arr, [ 'littleit', 'lit' ];
push @arr, [ 'london',   'lon' ];

for my $n (@arr) {
    my @p = unique_sub( $n->@* );
    say ' ';
    for my $o (@p) {
        state $c = 0;
        $c++;
        my $string = display_sub( $n->[0], $o );
        say qq{  $c:  $string };

    }
}

sub unique_sub ( $S, $T, $p = 0, $q = 0, $done = undef ) {
    if ( $p > length $S ) { return }
    $done //= [];
    my @output;
    my $l1 = substr $S, $p, 1;
    my $l2 = substr $T, $q, 1;
    my $key = join '.', $done->@*;

    if ( $q == length $T ) {
        push @output, $key;
    }
    my $copy->@* = $done->@*;
    push @output, unique_sub( $S, $T, $p + 1, $q, $copy );
    if ( $l1 eq $l2 ) {
        push $copy->@*, $p;
        push @output, unique_sub( $S, $T, $p + 1, $q + 1, $copy );
    }
    return uniq sort @output;
}

sub display_sub ( $string, $key ) {
    my @key = split /\D/, $key;
    my %key = map { $_ => 1 } @key;
    my $state = 0;
    my $output;

    for my $i ( 0 .. length $string ) {
        my $l = substr( $string, $i, 1 );
        my $k = $key{$i} || 0;
        my $L = $k ? uc $l : $l;
        # $output .= $L;

        $output .= ' [' if $state == 0 && $k == 1;
        $output .= '] ' if $state == 1 && $k == 0;
        $output .= $l;
        $state = $k;
    }

    $output .= '] ' if $state == 1;
    $output =~ s/^\s+//mix;
    return $output;
}
