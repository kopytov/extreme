# NAME

extreme - enables all stable & experimental features

# VERSION

version 0.001

# SYNOPSIS

    use extreme;

This equals to:

    # on perl v5.22
    use v5.22;
    use warnings;
    use utf8;
    use experimental qw( autoderef lexical_subs lexical_topic postderef
      regex_sets refaliasing signatures smartmatch );

    # on perl v5.20
    use v5.20;
    use warnings;
    use utf8;
    use experimental qw( autoderef lexical_subs lexical_topic postderef
      regex_sets signatures smartmatch );

    # on perl v5.18
    use v5.18;
    use warnings;
    use utf8;
    use experimental qw( autoderef lexical_subs lexical_topic postderef
      regex_sets smartmatch );

    # on perl v5.16
    use v5.16;
    use warnings;
    use utf8;

    # on perl v5.14
    use v5.14;
    use warnings;
    use utf8;

    # on perl v5.12
    use v5.12;
    use warnings;
    use utf8;

    # on perl v5.10
    use v5.10;
    use strict;
    use warnings;
    use utf8;

You can also specify perl version manually to load features of previous
releases and disable importing utf8.

    use extreme version => v5.18;

    # or

    use extreme version => v5.18, noutf8 => 1;

To disable extreme just use:

    use extreme;

    {
        no extreme; # this disables features, but strict, warnings
                    # and utf8 are still enabled
        my sub hello ($world) { say "hello $world" } # dies
    }

    my sub bye ($world) { say "bye $world" } # lives

# INSTALL

    cpanm -M http://cpan.fozzy.com/public extreme

# AUTHOR

Dmitry Kopytov <kopytov@webhackers.ru>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Dmitry Kopytov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
