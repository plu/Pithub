#!/usr/bin/env perl

use strict;
use warnings;

use CHI                    ();
use Pithub::Repos          ();
use WWW::Mechanize::Cached ();

my $cache = CHI->new(
    driver   => 'File',
    root_dir => '/tmp/pithub-example'
);

my $mech = WWW::Mechanize::Cached->new( cache => $cache );

my $b = Pithub::Repos->new(
    auto_pagination => 1,
    per_page        => 100,
    ua              => $mech,
);
my $result = $b->branches( user => 'plu', repo => 'Pithub' );

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}

while ( my $row = $result->next ) {
    printf "%s\n", $row->{name};
}
