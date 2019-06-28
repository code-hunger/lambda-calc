#!/usr/bin/env perl6

role Term {
    method parse (Str $str, &parse) { ... }
    method print (Int $indent = 0) { ... }
}

class Ap does Term {
    has $.left;
    has $.right;

    method parse($str, &parse) {
        return unless $str.substr(0, 1) eq '('; # A term must start with a '('!
        
        my ($len1, $left) = (parse $str.substr(1) // return);

        my $rest = $str.substr($len1 + 1);

        my ($len2, $right) = (parse $rest // return);

        return unless $rest.substr($len2, 1) eq ')'; # A term must end in a ')'!

        return 1 + $len1 + $len2 + 1,
            self.new(left => $left, right => $right);
    }

    method print(Int $indent = 0) {
        say ' ' x $indent*2, 'Ap: ';
        $.left.print($indent + 1);
        $.right.print($indent + 1);
    }
}

class Var does Term {
    has $.len; # Longer variables are possible: x1, y2, z12
    has $.name;

    sub get-var (Str $c where .chars > 0) {
        return $c ~~ /^<alpha><digit>*/;
    }

    method parse(Str $str) {
        .chars, self.new(len => .chars, name => .Str) with get-var $str;
    }

    method print(Int $indent = 0) {
        say ' ' x $indent*2, $.name;
    }

    method Str { $.name }
}

class Abstr does Term {
    has $.var;
    has $.term;

    sub add-abstractions ($term, @vars) {
        return $term unless @vars.elems;

        Abstr.new(var => @vars[0], term => add-abstractions($term, @vars[1..*]))
    }

    sub parse-var-list (Str $str) {
        my @vars ;
        my $vars-len = 0;

        while Var.parse($str.substr($vars-len)) -> ($len, $var) {
            push @vars, $var;
            $vars-len += $len;
        }

        return $vars-len, @vars;
    }

    method parse(Str $str, &parse) {
        return unless $str ~~ /^\(<[Llλ]>/;

        my ($vars-len, $vars) = parse-var-list $str.substr(2);
        return unless $vars && $str.substr($vars-len + 2, 1) eq '.';

        my ($term-len, $term) = (parse $str.substr($vars-len + 3) orelse return);
        return unless $str.substr(2 + $vars-len + 1 + $term-len, 1) eq ')';

        my $total-len = 2 + $vars-len + $term-len + 1;
        return $total-len, add-abstractions $term, $vars;
    }

    method print(Int $indent = 0) {
        say ' ' x $indent*2 ~ "λ $.var";
        $.term.print($indent + 1);
    }
}

my constant @terms = Var, Ap, Abstr;

sub parse($str) {
    return $_ with Var.parse($str);

    for [Ap, Abstr] -> $term {
        return $_ with $term.parse($str, &parse);
    }
}

my ($len, $term) = parse "(lyy1y.((x(y(λz1z3.a))b)))";

say $term.print;
