unit module nameless-terms;

class Var { ... };
class Ap { ... };
class Abstr { ... };

subset Term is export where Var | Abstr | Ap;

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

    # Returns the context $term needs so that it receives exactly as many
    # variables as it wants
    method adjust-context (@context, $term where $.left | $.right) {
        # This slice tries (seemingly) to evaluate the whole @context which
        # makes it impossible to use an infinite context
        return @context[$.depth - $term.depth .. *]
    }

    method print(@context, Str $indent = "") {
        say $indent ~ 'Ap: ';
        my ($adj-left, $adj-right) = self.adjust-context(@context, $.left),
                                     self.adjust-context(@context, $.right);

        $.left.print($adj-left, $indent ~ '|');
        $.right.print($adj-right, $indent ~ '|');
    }
}

class Abstr is export {
    has Term $.term;
    has Int $.depth;

    method print(@context, Str $indent = "") {
        say $indent ~ 'λ ' ~ @context[$.depth - 1];

        $.term.print(@context, $indent ~ '  ');
    }
}

