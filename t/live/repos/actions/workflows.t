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

    subtest 'list and get workflows' => sub {
        my $result = $p->repos->actions->workflows->list(
            user => 'Perl',
            repo => 'docker-perl-tester'
        );
        is(
            $result->success, 1,
            'Pithub::Repos::Actions::Workflows->branches successful'
        );
        ok( $result->count > 0, 'has some rows' );
        my $id = $result->content->{workflows}[0]{id};
        ok( $id, 'workflow id' );

        my $wf = $p->repos->actions->workflows->get(
            user        => 'Perl',
            repo        => 'docker-perl-tester',
            workflow_id => $id,
        );
        ok( $wf->success, 'success' );
        is( $wf->content->{id}, $id, 'id matches' );
    };
}

done_testing;
