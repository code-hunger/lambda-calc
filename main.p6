#!/usr/bin/env perl6

use lib '.';
use parse-named;
use parse-nameless;
use substitutions;

# Generates a 'x1 x2 x3...' sequence.
my constant @context = (0 ... 20).map('x' ~ *);
# @TODO Should work up to infinity (*), but for some reason it hangs when I
# make an infinite slice later, although I do not need the whole sequence
# evaluated. Look at nameless-terms.pm6, Ap::adjust-context().

sub parse-print ($str) {
    with parse-named::parse $str -> ($len, $term) {
        say "Parsed named term $str:";
        $term.print;
    }

    with parse-nameless::parse $str -> ($len, $term) {
        say "Parsed nameless term $str:";
        $term.print(@context);
    }

    print "\n";
}

sub subst-print($str is copy) {
    my regex term { <-[\|]>+ }
    my regex number { \d+ }
    my regex arrow { \→ }

    # Removing spaces from $str makes the regex more readable
    $str ~~ s:g/\s+//;

    with $str ~~ /^ (<term>) ( \| (<number>) <arrow> (<term>) )* $/ {
        my ($len, $term) = parse-nameless::parse $0.Str;
        warn "Couldn't parse $0" && return unless $term;

        say "Before substitution:";
        $term.print(@context);

        for $/[1] -> $substitution {
            my ($var, $repl) = ($substitution[0], $substitution[1]);

            with parse-nameless::parse $repl.Str -> ($len, $repl-term) {
                $term = substitute $term, $var.Int, $repl-term
            }
        }

        say "After substitution:";
        $term.print(@context);

        print "\n";
    }
}

sub MAIN($command = "parse")
{
    given $command {
        when "parse" {
            parse-print $_ for lines();
        }
        when "subst" {
            subst-print $_ for lines();
        }
        default {
            say 'Call with "parse" or "subst"' ;
        }
    }
}

