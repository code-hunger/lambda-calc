unit module substitutions;

use nameless-terms;

# Just in case.
subset Nat of Int where * >= 0;

multi substitute (Var $term, Nat $var, Term $replacement) is export {
    if $var == $term.id {
        return $replacement;
    }

    $term
}

multi substitute (Ap $term, Nat $var, Term $replacement) {
    my $left = substitute $term.left, $var, $replacement;
    my $right = substitute $term.right, $var, $replacement;

    Ap.new(left => $left, right => $right, depth => $left.depth max $right.depth);
}

multi substitute (Abstr $term, Nat $var, Term $replacement) {
    my $new-term = substitute $term.term, $var + 1, shift-up($replacement, 0);

    Abstr.new(term => $new-term, depth => 1 + $new-term.depth)
}

# $depth shows the head of the context, i.e. all vars bellow $depth should not
# be modified as they're captured by that beautiful greek letter.
multi shift-up (Var $term, Nat $depth) is export {
    my $new-val = $term.id + ($term.id < $depth ?? 0 !! 1);

    Var.new(id => $new-val, depth => $term.depth)
}

multi shift-up (Ap $term, Nat $depth) {
    Ap.new(left => shift-up($term.left, $depth),
           right => shift-up($term.right, $depth),
           depth => $term.depth)
}

multi shift-up (Abstr $term, Nat $depth) {
    Abstr.new(term => shift-up($term.term, $depth + 1),
              depth => $term.depth)
}

