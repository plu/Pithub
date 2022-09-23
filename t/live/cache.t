#!perl

use strict;
use warnings;

use CHI          ();
use Pithub       ();
use Scalar::Util qw( refaddr );
use Test::Most import => [qw( done_testing is isnt note plan subtest )];

plan skip_all => 'Set PITHUB_TEST_LIVE to true to run these tests'
    unless $ENV{PITHUB_TEST_LIVE};

subtest 'cached result' => sub {
    my $p       = Pithub->new;
    my $result1 = $p->request(
        method => 'GET',
        path   => '/'
    );

    my $result2 = $p->request(
        method => 'GET',
        path   => '/'
    );

    is( $result1->etag, $result2->etag, 'etags match' );
    is(
        refaddr $result1->response, refaddr $result2->response,
        'refaddr matches'
    );
};

subtest cache => sub {
    my $p = Pithub->new;

    my $hash = {};

    # Reduce the cache size to just two elements for easier testing
    $p->set_shared_cache(
        CHI->new(
            datastore => $hash,
            driver    => 'RawMemory',
            max_size  => 2,
            size      => 2,
        )
    );

    # Get two items to fill the cache
    my $repo_pithub = $p->repos->get( user => 'plu', repo => 'Pithub' );
    my $user_plu    = $p->users->get( user => 'plu' );

    # Get a third to bump $repo_pithub out
    my $branches = $p->repos->branches(
        user     => 'plu', repo => 'Pithub',
        per_page => 1
    );

    # Get $repo_pithub again, it should not be cached.
    my $repo_pithub2 = $p->repos->get( user => 'plu', repo => 'Pithub' );
    note @{ [ $repo_pithub->etag ] };
    note @{ [ $repo_pithub2->etag ] };
    isnt(
        refaddr $repo_pithub->response, refaddr $repo_pithub2->response,
        'refaddrs do not match after cache size exceeded'
    );
};

done_testing;
