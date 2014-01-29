#!/usr/bin/env perl
use strict;
use warnings;
use Pithub::Repos::Releases;
use Data::Dumper;

# https://api.github.com/repos/Graylog2/graylog2-server/releases
my $input = $ARGV[0] || 'Graylog2/graylog2-server';
my ($user, $repo) = split qr{/}, $input;

my $result = Pithub::Repos::Releases->new->list( user => $user, repo => $repo );

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}

while ( my $row = $result->next ) {
    printf "%s\n", $row->{name};
}
