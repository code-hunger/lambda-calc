unit module nameless-terms;

class Var { ... };
class Ap { ... };
class Abstr { ... };

subset Term where Var | Abstr | Ap;

class Var is export {
    has Int $.id;
    has Int $.depth = 0;

    method print(@context, Str $indent = "") {
        say $indent ~ @context[$.id];
    }
    method Str { $.id }
}

class Ap is export {
    has Term $.left;
    has Term $.right;
    has Int $.depth;

    method print(@context, Str $indent = "") {
        say $indent ~ 'Ap: ';
        $.left.print(@context, $indent ~ '|');
        $.right.print(@context, $indent ~ '|');
    }
}

class Abstr is export {
    has Term $.term;
    has Int $.depth;

    method print(@context, Str $indent = "") {
        say $indent ~ "λ";

        # The current 'head' of the @context is $.depth
        my $term-head = $.depth - 1 - $.term.depth;
        $.term.print(@context[$term-head .. *], $indent ~ '  ');
    }
}

