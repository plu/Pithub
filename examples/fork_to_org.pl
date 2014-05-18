#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Pithub::Repos::Forks;

my $fork = Pithub::Repos::Forks->new(
    token => $ENV{GITHUB_TOKEN},
);

my $result = $fork->create(
    org  => 'my_org',
    user => 'plu',
    repo => 'Pithub',
);
