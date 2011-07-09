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
            like $row->{url}, qr{https://api.github.com/gists/comments/\d+$}, "Pithub::Gists::Comments->list has url: $row->{url}";
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

    # Pithub::Gists->fork

    {

        # Pithub::Issues->create
        my $issue_id = $p->issues->create(
            data => {
                body  => 'Your software breaks if you do this and that',
                title => 'Found a bug',
            }
        )->content->{number};

        # Pithub::Issues->get
        is $p->issues->get( issue_id => $issue_id )->content->{title}, 'Found a bug', 'Pithub::Issues->get title attribute';

        # Pithub::Issues->update
        ok $p->issues->update(
            issue_id => $issue_id,
            data     => {
                body  => 'Your software breaks if you do this and that',
                title => 'Found a bug [UPDATED]',
            }
        )->success, 'Pithub::Issues->update successful';

        # Pithub::Issues->get
        is $p->issues->get( issue_id => $issue_id )->content->{title}, 'Found a bug [UPDATED]', 'Pithub::Issues->get updated title attribute';

        # Pithub::Issues->list
        is $p->issues->list->first->{number}, $issue_id, 'Pithub::Issues->list first item';

        # Pithub::Issues::Comments->create
        my $comment_id = $p->issues->comments->create(
            issue_id => $issue_id,
            data     => { body => 'some comment' }
        )->content->{id};

        # Pithub::Issues::Comments->get
        is $p->issues->comments->get( comment_id => $comment_id )->content->{body}, 'some comment', 'Pithub::Issues::Comments->get body attribute';

        # Pithub::Issues::Comments->list
        is $p->issues->comments->list( issue_id => $issue_id )->first->{body}, 'some comment', 'Pithub::Issues::Comments->list updated attribute';

        # Pithub::Issues::Comments->update
        ok $p->issues->comments->update(
            comment_id => $comment_id,
            data       => { body => 'some UPDATED comment' }
        )->success, 'Pithub::Issues::Comments->update successful';

        # Pithub::Issues::Comments->get
        is $p->issues->comments->get( comment_id => $comment_id )->content->{body}, 'some UPDATED comment',
          'Pithub::Issues::Comments->get updated body attribute';

        # Pithub::Issues::Comments->delete
        ok $p->issues->comments->delete( comment_id => $comment_id )->success, 'Pithub::Issues::Comments->delete successful';

        # Pithub::Issues::Comments->get
        ok !$p->issues->comments->get( comment_id => $comment_id )->success, 'Pithub::Issues::Comments->get not successful after delete';

        # Pithub::Issues::Labels->create
        ok $p->issues->labels->create(
            data => {
                color => 'FF0000',
                name  => "label #$_",
            }
          )->success, 'Pithub::Issues::Labels->create successful'
          for 1 .. 2;

        # Pithub::Issues::Labels->get
        is $p->issues->labels->get( label => 'label #1' )->content->{color}, 'FF0000', 'Pithub::Issues::Labels->get new label';

        # Pithub::Issues::Labels->update
        ok $p->issues->labels->update(
            label => 'label #1',
            data  => { color => 'C0FF33' }
        )->success, 'Pithub::Issues::Labels->update successful';

        # Pithub::Issues::Labels->get
        is $p->issues->labels->get( label => 'label #1' )->content->{color}, 'C0FF33', 'Pithub::Issues::Labels->get updated label';

        # Pithub::Issues::Labels->list
        is $p->issues->labels->list( issue_id => $issue_id )->count, 0, 'Pithub::Issues::Labels->list no labels attached to the issue yet';

        # Pithub::Issues::Labels->add
        ok $p->issues->labels->add( issue_id => $issue_id, data => [ 'label #1', 'label #2' ] )->success, 'Pithub::Issues::Labels->add successful';

        # Pithub::Issues::Labels->list
        is $p->issues->labels->list( issue_id => $issue_id )->count, 2, 'Pithub::Issues::Labels->list one label attached to the issue';

        # Pithub::Issues::Labels->remove
        ok $p->issues->labels->remove( issue_id => $issue_id, label => 'label #1' )->success, 'Pithub::Issues::Labels->remove successful';

        # Pithub::Issues::Labels->list
        is $p->issues->labels->list( issue_id => $issue_id )->count, 1, 'Pithub::Issues::Labels->list label removed again';

        # Pithub::Issues::Labels->replace
        ok $p->issues->labels->replace( issue_id => $issue_id, data => ['label #2'] )->success, 'Pithub::Issues::Labels->replace successful';

        # Pithub::Issues::Labels->list
        is $p->issues->labels->list( issue_id => $issue_id )->count, 1, 'Pithub::Issues::Labels->list one label';
        is $p->issues->labels->list( issue_id => $issue_id )->first->{name}, 'label #2', 'Pithub::Issues::Labels->list label got replaced';

        # Pithub::Issues::Labels->remove
        ok $p->issues->labels->remove( issue_id => $issue_id ), 'Pithub::Issues::Labels->remove all labels';

        # Pithub::Issues::Labels->list
        is $p->issues->labels->list( issue_id => $issue_id )->count, 0, 'Pithub::Issues::Labels->list no labels left';

        # Pithub::Issues::Labels->delete
        ok $p->issues->labels->delete( label => "label #$_" )->success, 'Pithub::Issues::Labels->delete successful' for 1 .. 2;

        # Pithub::Issues::Labels->get
        ok !$p->issues->labels->get( label => "label #$_" )->success, 'Pithub::Issues::Labels->get not successful after delete' for 1 .. 2;

        # Pithub::Issues::Milestones->create
        my $milestone_id = $p->issues->milestones->create( data => { title => 'some milestone' } )->content->{number};
        like $milestone_id, qr{^\d+$}, 'Pithub::Issues::Milestones->create returned a milestone number';

        # Pithub::Issues::Milestones->get
        is $p->issues->milestones->get( milestone_id => $milestone_id )->content->{title}, 'some milestone', 'Pithub::Issues::Milestones->get new milestone';

        # Pithub::Issues::Milestones->update
        ok $p->issues->milestones->update( milestone_id => $milestone_id, data => { title => 'updated' } )->success,
          'Pithub::Issues::Milestones->update successful';

        # Pithub::Issues::Milestones->get
        is $p->issues->milestones->get( milestone_id => $milestone_id )->content->{title}, 'updated', 'Pithub::Issues::Milestones->get updated title';

        # Pithub::Issues::Milestones->delete
        ok $p->issues->milestones->delete( milestone_id => $milestone_id )->success, 'Pithub::Issues::Milestones->delete successful';

        # Pithub::Issues::Milestones->get
        ok !$p->issues->milestones->get( milestone_id => $milestone_id )->success, 'Pithub::Issues::Milestones->get not successful after delete';
    }
}

done_testing;
