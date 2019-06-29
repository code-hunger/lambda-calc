#!/usr/bin/env perl6

use lib '.';
use parse-named;
use parse-nameless;

my @context = (0 .. 100).map('x'~*);

sub parse-print ($str) {
    with parse-named::parse $str -> ($len, $term) {
        say "Parsed named term $str:";
        $term.print;
    }

    with parse-nameless::parse $str -> ($len, $term) {
        say "Parsed nameless term $str:";
        $term.print(@context);
    }
}

parse-print $_ for lines();
