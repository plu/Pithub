use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

# Following tests require a token and should only be run on a test
# account since they will create a lot of activity in that account.
SKIP: {
    skip 'PITHUB_TEST_TOKEN required to run this test - DO NOT DO THIS UNLESS YOU KNOW WHAT YOU ARE DOING', 1 unless $ENV{PITHUB_TEST_TOKEN};

    my $org      = Pithub::Test->test_account->{org};
    my $org_repo = Pithub::Test->test_account->{org_repo};
    my $repo     = Pithub::Test->test_account->{repo};
    my $user     = Pithub::Test->test_account->{user};

    # Attention! Here we use $org and $org_repo
    my $p = Pithub->new(
        user  => $org,
        repo  => $org_repo,
        token => $ENV{PITHUB_TEST_TOKEN}
    );

    {

        # Pithub::PullRequests->create
        my $pr_id = $p->pull_requests->create(
            data => {
                base  => 'buhtip-org:master',
                body  => 'Please pull this in!',
                head  => "${user}:master",
                title => 'Amazing new feature',
            }
        )->content->{number};
        like $pr_id, qr{^\d+$}, 'Pithub::PullRequests->create successful, returned pull request number';

        # Pithub::PullRequests->commits
        is $p->pull_requests->commits( pull_request_id => $pr_id )->first->{sha}, '52ad3a8c84b8a480c16b616a4c1e7505aa20f64a',
          'Pithub::PullRequests->commit first SHA';

        # Pithub::PullRequests->files
        is $p->pull_requests->files( pull_request_id => $pr_id )->first->{filename}, 'dist.ini', 'Pithub::PullRequests->files first filename';

        # Pithub::PullRequests->update
        ok $p->pull_requests->update( pull_request_id => $pr_id, data => { title => "updated title $$" } )->success, 'Pithub::PullRequests->update successful';

        # Pithub::PullRequests->get
        is $p->pull_requests->get( pull_request_id => $pr_id )->content->{title}, "updated title $$", 'Pithub::PullRequests->get after update';

        # Pithub::PullRequests->list
        is $p->pull_requests->list->content->[-1]->{title}, "updated title $$", 'Pithub::PullRequests->list after update';

        # Pithub::PullRequests->is_merged
        ok !$p->pull_requests->is_merged( pull_request_id => $pr_id )->success,
          'Pithub::PullRequests->is_merged not successful yet, pull request not merged yet';

        # Pithub::PullRequests::Comments->create
        # Pithub::PullRequests::Comments->delete
        # Pithub::PullRequests::Comments->get
        # Pithub::PullRequests::Comments->list
        # Pithub::PullRequests::Comments->update

        # Pithub::PullRequests->update
        ok $p->pull_requests->update( pull_request_id => $pr_id, data => { state => 'closed' } )->success,
          'Pithub::PullRequests->update closing the pull request';
    }
}

done_testing;
