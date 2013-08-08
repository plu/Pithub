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

    # Pithub::Gists->get
    {
        my $result = $p->gists->get( gist_id => 1 );
        is $result->success, 1, 'Pithub::Gists->get successful';
        is $result->content->{created_at}, '2008-07-15T18:17:13Z', 'Pithub::Gists->get created_at';
    }

    # Pithub::Gists->list
    {
        my $result = $p->gists->list( public => 1 );
        is $result->success, 1, 'Pithub::Gists->list successful';
        while ( my $row = $result->next ) {
            ok $row->{id}, "Pithub::Gists->list has id: $row->{id}";
            like $row->{url}, qr{https://api.github.com/gists/\d+$}, "Pithub::Gists->list has url: $row->{url}";
        }
    }

    # Pithub::Gists::Comments->list
    {
        my $result = $p->gists->comments->list( gist_id => 1 );
        is $result->success, 1, 'Pithub::Gists::Comments->list successful';
        while ( my $row = $result->next ) {
            ok $row->{id}, "Pithub::Gists::Comments->list has id: $row->{id}";
            like $row->{url}, qr{https://api.github.com/gists/\d+/comments/\d+$}, "Pithub::Gists::Comments->list has url: $row->{url}";
        }
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

    {

        # Pithub::Gists->create
        my $gist_id = $p->gists->create(
            data => {
                description => 'the description for this gist',
                public      => 1,
                files       => { 'file1.txt' => { content => 'String file content' } }
            }
        )->content->{id};

        # Pithub::Gists->is_starred
        ok !$p->gists->is_starred( gist_id => $gist_id )->success, 'Pithub::Gists->is_starred not successful, gist not starred yet';

        # Pithub::Gists->star
        ok $p->gists->star( gist_id => $gist_id )->success, 'Pithub::Gists->star successful';

        # Pithub::Gists->is_starred
        ok $p->gists->is_starred( gist_id => $gist_id )->success, 'Pithub::Gists->is_starred successful, gist is starred now';

        # Pithub::Gists->unstar
        ok $p->gists->unstar( gist_id => $gist_id )->success, 'Pithub::Gists->unstar successful';

        # Pithub::Gists->is_starred
        ok !$p->gists->is_starred( gist_id => $gist_id )->success, 'Pithub::Gists->is_starred not successful, gist not starred anymore';

        # Pithub::Gists->get
        is $p->gists->get( gist_id => $gist_id )->content->{description}, 'the description for this gist', 'Pithub::Gists->get file content';

        # Pithub::Gists->update
        ok $p->gists->update(
            gist_id => $gist_id,
            data    => { description => 'the UPDATED description for this gist' }
        )->success, 'Pithub::Gists->update successful';

        # Pithub::Gists->get
        is $p->gists->get( gist_id => $gist_id )->content->{description}, 'the UPDATED description for this gist', 'Pithub::Gists->get file content';

        # Pithub::Gists::Comments->create
        my $comment_id = $p->gists->comments->create( gist_id => $gist_id, data => { body => 'some gist comment' } )->content->{id};
        like $comment_id, qr{^\d+$}, 'Pithub::Gists::Comments->create returned a comment id';

        # Pithub::Gists::Comments->get
        is $p->gists->comments->get( comment_id => $comment_id )->content->{body}, 'some gist comment', 'Pithub::Gists::Comments->get body';

        # Pithub::Gists::Comments->update
        ok $p->gists->comments->update( comment_id => $comment_id, data => { body => 'some UPDATED gist comment' } )->success,
          'Pithub::Gists::Comments->update successful';

        # Pithub::Gists::Comments->get
        is $p->gists->comments->get( comment_id => $comment_id )->content->{body}, 'some UPDATED gist comment',
          'Pithub::Gists::Comments->get body after update';

        # Pithub::Gists::Comments->delete
        ok $p->gists->comments->delete( comment_id => $comment_id )->success, 'Pithub::Gists::Comments->delete successful';

        # Pithub::Gists::Comments->get
        ok !$p->gists->comments->get( comment_id => $comment_id )->success, 'Pithub::Gists::Comments->get not successful after delete';

        # Pithub::Gists->delete
        ok $p->gists->delete( gist_id => $gist_id )->success, 'Pithub::Gists->delete successful';

        # Pithub::Gists->get
        ok !$p->gists->get( gist_id => $gist_id )->success, 'Pithub::Gists->get not successful after delete';
    }
}

done_testing;
