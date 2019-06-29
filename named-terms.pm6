unit module named-terms;

class Var { ... };
class Ap { ... };
class Abstr { ... };

subset Term where Var | Abstr | Ap;

class Ap is export {
    has Term $.left;
    has Term $.right;

    method print(Str $indent = "") {
        say $indent ~ 'Ap: ';
        $.left.print($indent ~ '|');
        $.right.print($indent ~ '|');
    }
}

class Var is export {
    has $.len; # Longer variables are possible: x1, y2, z12
    has $.name;
    method print(Str $indent = "") { say $indent ~ $.name; }

    method Str { $.name }
}

class Abstr is export {
    has Var $.var;
    has Term $.term;

    method print(Str $indent = "") {
        say $indent ~ "λ $.var";
        $.term.print($indent ~ '  ');
    }
}

