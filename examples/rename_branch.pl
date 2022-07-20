#!/usr/bin/env perl

use strict;
use warnings;
use Pithub::Repos ();

my $b = Pithub::Repos->new(
    token           => "ghp_YoUrTokeN"
);

# Rename branch
my $result = $b->rename_branch( user => 'plu', repo => 'Pithub', branch => 'name', data => { new_name => 'newname' } );

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}
