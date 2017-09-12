
package Sub::Inject;

# ABSTRACT: Inject subroutines into a lexical scope

use 5.018;

require XSLoader;
XSLoader::load(__PACKAGE__);

1;

=encoding utf8

=head1 NAME

Sub::Inject - Inject subroutines into a lexical scope

=head1 SYNOPSIS

    use Sub::Inject;   # requires perl 5.18+

    {
        BEGIN { Sub::Inject::sub_inject( 'one', sub { say "One!" } ); }
        one();    # says "One!"
    }

    one();    # throws "Undefined subroutine &main::one called"

=head1 DESCRIPTION

This module allows to dynamically inject lexical subs
during compilation. It is implemented using
lexical subroutines introduced in perl 5.18.

This is a low level library. It is meant for cases where
subroutine names and bodies are to be treated as data
or not known in advance. Otherwise, lexical subs syntax
is recommended. For instance,

    use experimental qw(lexical_subs);
    state sub foo { say "One!" }

is the static equivalent of

    BEGIN {
        Sub::Inject::sub_inject( 'one', sub { say "One!" } );
    }

=head1 HOW IT WORKS

Used like

    BEGIN { Sub::Inject::sub_inject('foo', sub { ... }) }

it will work as

    \state &foo = sub { ... };

That means:

=over 4

=item *

being a true lexical provides consistent behavior
based on scope

=item *

being a "state" lexical guarantees the persistence
of the association between the name and the subroutine,

=item *

the reference aliasing operation means no copy is done,

=back


=head1 FUNCTIONS

=head2 sub_inject

    sub_inject($name, $code);
    sub_inject($name1, $code1, $name2, $code2);

Injects C<$code> as a lexical subroutine named C<$name>
into the currently compiling scope. The same applies
to multiple name / code pairs given as input.

Throws an error if called at runtime.

=head1 ACKNOWLEDGEMENTS

This code is a fork of "Lexical.xs" file from
L<Exporter-Lexical distribution|https://metacpan.org/release/Exporter-Lexical>
by L<Jesse Luehrs|https://metacpan.org/author/DOY>.

=head1 SEE ALSO

L<perlsub/"Lexical Subroutines">

L<feature/"The 'lexical_subs' feature">

L<Exporter::Lexical> and L<lexically>

=cut
