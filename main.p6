#!/usr/bin/env perl6

use lib '.';
use parse-named;
use parse-nameless;

# Generates a 'x1 x2 x3...' sequence. 
my @context = (0 .. 100).map('x' ~ *);
# @TODO Should work up to infinity (*), but for
# some reason it can't make an infinite slice later, although I do not need it
# to evaluate the whole sequence. 
# Look at nameless-terms.pm6, Ap::adjust-context().

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
