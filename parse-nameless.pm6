use nameless-terms;

sub parse-var(Str $str, Int $depth) {
    with $str ~~ /^<digit>+/ -> $match {
        return $match.chars, Var.new(id => ($match.Int))
    }
}

sub parse-ap($str, $depth, &parse) {
    return unless $str.substr(0, 1) eq '('; # A term must start with a '('!

    my ($len1, $left) = (parse($str.substr(1)) // return);
    my $rest = $str.substr($len1 + 1);

    # Allow ' ' or '.' to sit between applications to separate variables
    # Otherwise (42.42) would be read as a single variable (4242)
    $rest .= substr(1) if $rest.substr(0, 1) eq '.' | ' ';

    my ($len2, $right) = (parse($rest) // return);
    return unless $rest.substr($len2, 1) eq ')'; # A term must end in a ')'!

    return 1 + $len1 + $len2 + 1,
    Ap.new(left => $left, right => $right);
}

sub apply-abstractions ($term, Int $lambdas where * >= 0) {
    return $term unless $lambdas;

    Abstr.new(term => apply-abstractions $term, $lambdas - 1)
}

sub parse-abstr(Str $str, &parse) {
    return unless $str ~~ /^\( ( <[Llλ]>+ )/;
    my $lambdas-len = $/[0].chars;

    my ($term-len, $term) = (parse($str.substr(1 + $lambdas-len)) orelse return);
    return unless $str.substr(1 + $lambdas-len + $term-len, 1) eq ')';

    return 1 + $lambdas-len + $term-len + 1, apply-abstractions $term, $lambdas-len;
}

our sub parse-nameless($str) {
    return $_ with parse-var($str);
    return $_ with parse-abstr($str, &parse-nameless);
    return $_ with parse-ap($str, &parse-nameless);
}

