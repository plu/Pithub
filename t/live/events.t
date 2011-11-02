use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

# These tests may break very easily because data on Github can and will change, of course.
# And they also might fail once the ratelimit has been reached.
SKIP: {
    skip 'Set PITHUB_TEST_LIVE_DATA to true to run these tests', 1 unless $ENV{PITHUB_TEST_LIVE_DATA};

    my $p = Pithub->new;

    # Pithub::Events->issue
    {
        my $result = $p->events->issue( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Events->issue successful';
        ok $result->count > 0, 'Pithub::Events->issue has some rows';
    }

    # Pithub::Events->network
    {
        my $result = $p->events->network( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Events->network successful';
        ok $result->count > 0, 'Pithub::Events->network has some rows';
    }

    # Pithub::Events->org
    {
        my $result = $p->events->org( org => 'CPAN-API' );
        is $result->success, 1, 'Pithub::Events->org successful';
        ok $result->count > 0, 'Pithub::Events->org has some rows';
    }

    # Pithub::Events->public
    {
        my $result = $p->events->public;
        is $result->success, 1, 'Pithub::Events->public successful';
        ok $result->count > 0, 'Pithub::Events->public has some rows';
        ok $result->content->[0]{public}, 'Pithub::Events->public: Attribute public'
    }

    # Pithub::Events->repos
    {
        my $result = $p->events->repos( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Events->repos successful';
        ok $result->count > 0, 'Pithub::Events->repos has some rows';
    }

    # Pithub::Events->user_performed
    {
        my $result = $p->events->user_performed( user => 'plu' );
        is $result->success, 1, 'Pithub::Events->user_performed successful';
        ok $result->count > 0, 'Pithub::Events->user_performed has some rows';
    }

    # Pithub::Events->user_received
    {
        my $result = $p->events->user_received( user => 'plu' );
        is $result->success, 1, 'Pithub::Events->user_received successful';
        ok $result->count > 0, 'Pithub::Events->user_received has some rows';
    }
}

# Following tests require a token and should only be run on a test
# account since they will create a lot of activity in that account.
SKIP: {
    skip 'PITHUB_TEST_TOKEN required to run this test - DO NOT DO THIS UNLESS YOU KNOW WHAT YOU ARE DOING', 1 unless $ENV{PITHUB_TEST_TOKEN};

    my $org      = Pithub::Test->test_account->{org};
    my $org_repo = Pithub::Test->test_account->{org_repo};
    my $repo     = Pithub::Test->test_account->{repo};
    my $user     = Pithub::Test->test_account->{user};
    my $p        = Pithub->new(
        user  => $user,
        repo  => $repo,
        token => $ENV{PITHUB_TEST_TOKEN}
    );

    # Pithub::Events->org_for_user
    {
        my $result = $p->events->org_for_user( org => $org, user => $user );
        is $result->success, 1, 'Pithub::Events->org_for_user successful';
        ok $result->count > 0, 'Pithub::Events->org_for_user has some rows';
    }
}

done_testing;
