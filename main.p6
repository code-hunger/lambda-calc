#!/usr/bin/env perl6

use lib '.';
use parse-named;

my ($len, $term) = parse "(lyy1y.((x(y(λz1z3.a))b)))";

say $term.print;
