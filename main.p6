#!/usr/bin/env perl6

use lib '.';
use parse-named;
use parse-nameless;

{
    my ($len, $term) = parse "(lyy1y.((x(y(λz1z3.a)))b))";
    say $term.print;
}

{
    my ($len, $term) = parse-nameless::parse "(ll((l(2.(ll(9.6))))(l(1.2))))";

    say "Parsed" with $term;

    my @context = (0 .. 100).map('x'~*);

    $term.print(@context).say with $term;
}
