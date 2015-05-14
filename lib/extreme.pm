# ABSTRACT: enables all stable & experimental features
package extreme;

use strict;
use warnings;

require feature;
require utf8;
require version;
use Carp;

my %is_experimental = map { substr( $_, 14 ) => 1 }
  grep {/^experimental::/} keys %warnings::Offsets;
my %is_feature = map { $_ => 1 } $] > 5.015006 ? keys %feature::feature : do {
    my @features;
    if ( $] >= 5.010 ) {
        push @features, qw/switch say state/;
        push @features, 'unicode_strings' if $] > 5.011002;
    }
    @features;
};

my @enabled_experimentals = ();
my @enabled_features      = ();

my %experiments_of = (
    5      => [qw( array_base )],
    5.010  => [qw( lexical_topic say smartmatch state switch )],
    5.012  => [qw( unicode_strings )],
    5.014  => [qw( autoderef )],
    5.016  => [qw( current_sub evalbytes fc unicode_eval )],
    5.018  => [qw( lexical_subs regex_sets )],
    5.020  => [qw( postderef postderef_qq signatures )],
    5.0215 => [qw( refaliasing )],
);

sub import {
    shift;
    my %opt = @_;
    my $version = exists $opt{version} ? version->parse( $opt{version} ) : $];
    strict->import();
    warnings->import();
    utf8->import() if !$opt{noutf8};
    return if $version < 5.010;
    for my $min_version ( sort keys %experiments_of ) {
        last if $version < $min_version;
        for my $experiment ( @{ $experiments_of{$min_version} } ) {
            if ( $is_experimental{$experiment} ) {
                warnings->unimport("experimental::$experiment");
                push @enabled_experimentals, $experiment;
            }
            if ( $is_feature{$experiment} ) {
                feature->import($experiment);
                push @enabled_features, $experiment;
            }
        }
    }
    return;
}

sub unimport {
    for my $experiment (@enabled_experimentals) {
        warnings->import("experimental::$experiment");
    }
    for my $experiment (@enabled_features) {
        feature->unimport($experiment);
    }
    return;
}

1;

__END__

=head1 SYNOPSIS

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
