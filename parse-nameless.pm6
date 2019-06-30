unit module parse-nameless;

use nameless-terms;

sub parse-var(Str $str) {
    with $str ~~ /^<digit>+/ -> $match {
        return $match.chars, Var.new(id => $match.Int)
    }
}

sub parse-ap($str, &parse) {
    return unless $str.substr(0, 1) eq '('; # A term must start with a '('!

    my ($len1, $left) = parse($str.substr(1)) // return;
    my $rest = $str.substr($len1 + 1);

    # Allow ' ' or '.' to sit between applications to separate variables
    # Otherwise (42.42) would be read as a single variable (4242)
    my $has-separator = so $rest.substr(0, 1) eq '.' | ' ' ;

    $rest .= substr(1) if $has-separator;

    my ($len2, $right) = parse($rest) // return;
    return unless $rest.substr($len2, 1) eq ')'; # A term must end in a ')'!

    return 1 + $len1 + ($has-separator) + $len2 + 1,
        Ap.new(left => $left, right => $right, depth => $left.depth max $right.depth);
}

sub apply-abstractions ($term, Int $lambdas where * >= 0) {
    return $term unless $lambdas;

    Abstr.new(term => apply-abstractions($term, $lambdas - 1),
              depth => $term.depth + $lambdas)
}

my regex lambda { <[Llλ]> }

sub parse-abstr(Str $str, &parse) {
    return unless $str ~~ /^\( (<lambda>+)/; # Must start with '(λ'
    my $lambdas-count = $/[0].chars; # We allow many λ's at once

    my ($term-len, $term) = parse($str.substr(1 + $lambdas-count)) // return;
    return unless $str.substr(1 + $lambdas-count + $term-len, 1) eq ')';

    return 1 + $lambdas-count + $term-len + 1, apply-abstractions $term, $lambdas-count;
}

our sub parse($str) {
    return $_ with parse-var($str);
    return $_ with parse-abstr($str, &parse);
    return $_ with parse-ap($str, &parse);
}

