package Pithub::Test;

use Import::Into;
use Test::Most;

BEGIN {
    require Exporter;
    our @ISA    = qw(Exporter);
    our @EXPORT = qw(uri_is);
}

sub import {
    my $class  = shift;
    my $caller = caller;

    Test::Most->import::into($caller);

    $class->export_to_level(1, @_);
}

sub uri_is {
    my($have, $want, $name) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    $have = _make_uri($have);
    $want = _make_uri($want);

    for my $method (qw(scheme authority path fragment)) {
        my $have_val = $have->$method;
        my $want_val = $want->$method;

        next if !defined $have_val && !defined $want_val;
        if( (defined $have_val xor defined $want_val) ||
            ($have_val ne $want_val)
        ) {
            return is( $have, $want, $name ) || diag "$method does not match";
        }
    }

    my %have_queries = $have->query_form;
    my %want_queries = $want->query_form;
    return eq_or_diff( \%have_queries, \%want_queries, $name ) ||
             diag "$have ne $want, queries do not match";
}

sub _make_uri {
    my $uri = shift;

    return $uri if ref $uri && $uri->isa("URI");

    require URI;
    return URI->new($uri);
}

1;
