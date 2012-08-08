#!/usr/bin/env perl
use strict;
use warnings;
use Pithub::Issues::Assignees;

my $assignees = Pithub::Issues::Assignees->new(
    repo  => 'Pithub',
    token => $ENV{GITHUB_TOKEN},
    user  => 'plu',
);

use Data::Dumper;

warn Dumper $assignees->list->content;
