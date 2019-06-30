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

    say "Generated context: [$generated-context]";
    say "Unnamed and then named with an automatic context:";
    $unnamed.print(@context);

    print "\n";
}

unname-print $_ for lines();
