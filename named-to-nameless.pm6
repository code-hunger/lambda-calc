unit module unname-terms;

use named-terms;

multi unname(named-terms::Var $var, @context) is export {
    use nameless-terms;

    if @context.first(* eq $var, :kv) -> ($index, $el) {
        return @context, nameless-terms::Var.new: id => $index
    }

    return (@context, $var).flat, nameless-terms::Var.new: id => @context.elems
}

multi unname(named-terms::Ap $term, @context) {
    use nameless-terms;

    # Note how @context goes through $.left, then the output goes through
    # $.right, and the returned value is the final context. This means that
    # each of the inner terms gets a chance to modify it, adding more variables

    my ($context-l, $left) = unname $term.left, @context;
    my ($context-r, $right) = unname $term.right, $context-l;

    return $context-r, nameless-terms::Ap.new:
                            left => $left,
                            right => $right,
                            depth => $left.depth max $right.depth
}

multi unname(named-terms::Abstr $term, @context) {
    use nameless-terms;
    my ($context-in, $inner) = unname $term.term, ($term.var, @context).flat;

    # Note here the first variable from the generated context must be removed
    # because it is inaccessible outside of this abstraction
    return $context-in[1..*],
           nameless-terms::Abstr.new: term => $inner, depth => 1 + $inner.depth
}
