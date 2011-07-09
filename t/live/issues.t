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

    # Pithub::Issues::Labels->list
    {
        my $result = $p->issues->labels->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Issues::Labels->list successful';
        my @labels = splice @{ $result->content }, 0, 2;
        eq_or_diff \@labels,
          [
            {
                'color' => 'e10c02',
                'name'  => 'Bug',
                'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Bug'
            },
            {
                'color' => '02e10c',
                'name'  => 'Feature',
                'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Feature'
            }
          ],
          'Pithub::Issues::Labels->list content';
    }

    # Pithub::Issues::Labels->get
    {
        my $result = $p->issues->labels->get( user => 'plu', repo => 'Pithub', label => 'Bug' );
        is $result->success, 1, 'Pithub::Issues::Labels->get successful';
        eq_or_diff $result->content,
          {
            'color' => 'e10c02',
            'name'  => 'Bug',
            'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Bug'
          },
          'Pithub::Issues::Labels->get content';
    }

    # Pithub::Issues::Milestones->get
    {
        my $result = $p->issues->milestones->get( user => 'plu', repo => 'Pithub', milestone_id => 1 );
        is $result->success, 1, 'Pithub::Issues::Milestones->get successful';
        is $result->content->{creator}{login}, 'plu', 'Pithub::Issues::Milestones->get: Attribute creator.login';
    }

    # Pithub::Issues::Milestones->list
    {
        my $result = $p->issues->milestones->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Issues::Milestones->list successful';
        ok $result->count > 0, 'Pithub::Issues::Milestones->list has some rows';
        is $result->content->[0]{creator}{login}, 'plu', 'Pithub::Issues::Milestones->list: Attribute creator.login';
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
}

done_testing;
