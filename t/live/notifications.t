#!perl

use strict;
use warnings;

use Pithub ();
use Test::More import => [qw( done_testing ok skip )];

# These tests only read: they mark nothing as read or done.
# They might fail once the ratelimit has been reached.
SKIP: {
    skip
        'PITHUB_TEST_TOKEN required to run this test - DO NOT DO THIS UNLESS YOU KNOW WHAT YOU ARE DOING',
        1
        unless $ENV{PITHUB_TEST_TOKEN};

    my $p = Pithub->new( token => $ENV{PITHUB_TEST_TOKEN} );

    # Pithub::Notifications->list
    {
        my $result = $p->notifications->list( params => { per_page => 50 } );
        ok $result->success, 'Pithub::Notifications->list successful';
        ok $result->response->header('X-Poll-Interval'),
            'Pithub::Notifications->list has an X-Poll-Interval header';
    }
}

done_testing;
