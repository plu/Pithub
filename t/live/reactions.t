#!perl

use strict;
use warnings;

use Pithub ();
use Test::More import => [qw( done_testing is ok skip subtest )];

# These tests may break very easily because data on Github can and will change, of course.
# And they also might fail once the ratelimit has been reached.
SKIP: {
    skip 'Set PITHUB_TEST_LIVE_DATA to true to run these tests', 1
        unless $ENV{PITHUB_TEST_LIVE_DATA};

    my $p = Pithub->new;

    subtest 'list reactions for an issue' => sub {
        my $result = $p->reactions->list_for_issue(
            user     => 'plu',
            repo     => 'Pithub',
            issue_id => 209,
            params   => { content => 'eyes' },
        );
        is(
            $result->success, 1,
            'Pithub::Reactions->list_for_issue successful'
        );
        is( ref $result->content, 'ARRAY', 'content is a list' );
        ok( $result->count > 0, 'has some rows' );

        my @other = grep { $_->{content} ne 'eyes' } @{ $result->content };
        is( scalar @other, 0, 'the content filter was applied' );
    };
}

done_testing;
