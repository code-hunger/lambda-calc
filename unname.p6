#!/usr/bin/env perl6

use lib '.';
use parse-named;
use named-to-nameless;

my constant @context = (0 ... 20).map('x' ~ *);

sub unname-print($str) {
    my ($len, $named) = parse-named::parse($str) // return;

    say "Parsed $str:";
    $named.print();

    # The context here is thrown away, but can be used if needed
    my ($generated-context, $unnamed) = unname($named, ());

    say "Unnamed and named:";
    $unnamed.print(@context);
}

unname-print $_ for lines();
