#!/usr/bin/env perl

use strict;
use warnings;
use Pithub::Repos::Branches;

my $b = Pithub::Repos::Branches->new(
    token           => "ghp_YoUrTokeN"
);

# Rename branch
my $result = $b->rename( user => 'plu', repo => 'Pithub', data => { branch => 'oldname', new_name => 'newname' } );

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}

