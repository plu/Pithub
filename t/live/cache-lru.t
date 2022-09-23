#!perl

use strict;
use warnings;

use Pithub       ();
use Scalar::Util qw( refaddr );
use Test::Most import => [qw( done_testing isnt plan )];
use Test::Needs qw( Cache::LRU );

plan skip_all => 'Set PITHUB_TEST_LIVE to true to run these tests'
    unless $ENV{PITHUB_TEST_LIVE};

# This is a test to ensure that switching from Cache::LRU to CHI has not
# inadvertently broken something which depends on Pithub.
my $p = Pithub->new;

my $hash = {};

# Reduce the cache size to just two elements for easier testing
$p->set_shared_cache( Cache::LRU->new( size => 2 ) );

# Get two items to fill the cache
my $repo_pithub = $p->repos->get( user => 'plu', repo => 'Pithub' );
my $user_plu    = $p->users->get( user => 'plu' );

# Get a third to bump $repo_pithub out
my $branches = $p->repos->branches(
    user     => 'plu',
    repo     => 'Pithub',
    per_page => 1,
);

# Get $repo_pithub again, it should not be cached.
my $repo_pithub2 = $p->repos->get( user => 'plu', repo => 'Pithub' );
isnt(
    refaddr $repo_pithub->response, refaddr $repo_pithub2->response,
    'refaddrs do not match after cache size exceeded'
);

done_testing;
