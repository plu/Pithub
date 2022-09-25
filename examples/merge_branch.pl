#!/usr/bin/env perl

use strict;
use warnings;
use Pithub::Repos ();

my $b = Pithub::Repos->new( token => 'ghp_YoUrTokeN' );

# Merge a branch
my $result = $b->merge_branch(
    user => 'plu', repo => 'Pithub',
    data => { base => 'master', head => 'branch-to-merge' }
);

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}
