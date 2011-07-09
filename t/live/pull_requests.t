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
}

done_testing;
