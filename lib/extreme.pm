# ABSTRACT: enables all stable & experimental features
package extreme;

use strict;
use warnings;

require feature;
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
    my $version = $_[1] || $];
    strict->import();
    warnings->import();
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
