unit module nameless-terms;

class Var is export {
    has Int $.id;

    method print(@context, Str $indent = "") {
        say $indent ~ $.id ~ ": " ~ @context[$.id];
    }
    method Str { $.id }
}

class Ap is export {
    has $.left;
    has $.right;

    method print(@context, Str $indent = "") {
        say $indent ~ 'Ap: ';
        $.left.print(@context, $indent ~ '|');
        $.right.print(@context, $indent ~ '|');
    }
}

class Abstr is export {
    has $.term;

    method print(@context, Str $indent = "") {
        say $indent ~ "λ";
        $.term.print(@context[0..*-1], $indent ~ '  ');
    }
}

