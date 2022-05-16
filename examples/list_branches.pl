#!/usr/bin/env perl

use strict;
use warnings;
use Pithub::Repos::Branches;

my $b = Pithub::Repos::Branches->new(
    per_page        => 100,
    auto_pagination => 1,
);
my $result = $b->list( user => 'plu', repo => 'Pithub' );

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}

while ( my $row = $result->next ) {
    printf "%s\n", $row->{name};
}

