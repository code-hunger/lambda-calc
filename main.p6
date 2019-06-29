#!/usr/bin/env perl6

use lib '.';
use parse-named;
use parse-nameless;

{
    my ($len, $term) = parse "(lyy1y.((x(y(λz1z3.a)))b))";
    say $term.print;
}

{
    my ($len, $term) = parse-nameless "(ll(1(2.0)))";
    $term.print((loop {'x' ~$_})).say with $term;
}
