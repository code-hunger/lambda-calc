unit module terms;

class Ap is export {
    has $.left;
    has $.right;

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
    has $.var;
    has $.term;


    method print(Str $indent = "") {
        say $indent ~ "λ $.var";
        $.term.print($indent ~ '  ');
    }
}

