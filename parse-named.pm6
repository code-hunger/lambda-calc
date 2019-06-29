use term-defs;

sub get-var (Str $c where .chars > 0) {
    return $c ~~ /^<alpha><digit>*/;
}

sub parse-var(Str $str) {
    .chars, Var.new(len => .chars, name => .Str) with get-var $str;
}

sub add-abstractions ($term, @vars) {
    return $term unless @vars.elems;

    Abstr.new(var => @vars[0], term => add-abstractions($term, @vars[1..*]))
}

sub parse-ap($str, &parse) {
    return unless $str.substr(0, 1) eq '('; # A term must start with a '('!

    my ($len1, $left) = (parse($str.substr(1)) // return);
    my $rest = $str.substr($len1 + 1);

    my ($len2, $right) = (parse($rest) // return);
    return unless $rest.substr($len2, 1) eq ')'; # A term must end in a ')'!

    return 1 + $len1 + $len2 + 1,
    Ap.new(left => $left, right => $right);
}

sub parse-var-list (Str $str) {
    my @vars ;
    my $vars-len = 0;

    while parse-var($str.substr($vars-len)) -> ($len, $var) {
        push @vars, $var;
        $vars-len += $len;
    }

    return $vars-len, @vars;
}

sub parse-abstr(Str $str, &parse) {
    return unless $str ~~ /^\(<[Llλ]>/;

    my ($vars-len, $vars) = parse-var-list $str.substr(2);
    return unless $vars && $str.substr($vars-len + 2, 1) eq '.';

    my ($term-len, $term) = (parse($str.substr($vars-len + 3)) orelse return);
    return unless $str.substr(2 + $vars-len + 1 + $term-len, 1) eq ')';

    my $total-len = 2 + $vars-len + $term-len + 1;
    return $total-len, add-abstractions $term, $vars;
}

our sub parse($str) is export {
    return $_ with parse-var($str);
    return $_ with parse-abstr($str, &parse);
    return $_ with parse-ap($str, &parse);
}

