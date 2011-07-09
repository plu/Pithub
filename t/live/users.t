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

    # Pithub::Users->get
    {
        my $result = $p->users->get( user => 'plu' );
        is $result->success, 1, 'Pithub::Users->get successful';
        is $result->content->{id},    '31597',            "Pithub::Users->get: Attribute id";
        is $result->content->{login}, 'plu',              "Pithub::Users->get: Attribute login";
        is $result->content->{name},  'Johannes Plunien', "Pithub::Users->get: Attribute name";
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

        # Pithub::Users::Keys->create
        my $key_id = $p->users->keys->create(
            data => {
                title => 'someone@somewhere',
                key   => "ssh-rsa C0FF33$$",
            }
        )->content->{id};

        # Pithub::Users::Keys->get
        is $p->users->keys->get( key_id => $key_id )->content->{title}, 'someone@somewhere', 'Pithub::Users::Keys->get title attribute';

        # Pithub::Users::Keys->list
        is $p->users->keys->list->first->{title}, 'someone@somewhere', 'Pithub::Users::Keys->list title attribute';

        # Pithub::Users::Keys->update
        ok $p->users->keys->update(
            key_id => $key_id,
            data   => { title => 'someone@somewhereelse' }
        )->success, 'Pithub::Users::Keys->update successful';

        # Pithub::Users::Keys->get
        is $p->users->keys->get( key_id => $key_id )->content->{title}, 'someone@somewhereelse', 'Pithub::Users::Keys->get title attribute after update';

        # Pithub::Users::Keys->delete
        ok $p->users->keys->delete( key_id => $key_id )->success, 'Pithub::Users::Keys->delete successful';

        # Pithub::Users::Keys->get
        ok !$p->users->keys->get( key_id => $key_id )->success, 'Pithub::Users::Keys->get not successful after delete';
    }

    {

        # Pithub::Users::Emails->add
        ok $p->users->emails->add( data => ['johannes@plunien.name'] )->success, 'Pithub::Users::Emails->add successful';

        # Pithub::Users::Emails->list
        is $p->users->emails->list->content->[-1], 'johannes@plunien.name', 'Pithub::Users::Emails->list recently added email address';

        # Pithub::Users::Emails->delete
        ok $p->users->emails->delete( data => ['johannes@plunien.name'] )->success, 'Pithub::Users::Emails->delete successful';

        # Pithub::Users::Emails->list
        isnt $p->users->emails->list->content->[-1], 'johannes@plunien.name', 'Pithub::Users::Emails->list after delete';
    }

    {

        # Pithub::Users->update
        ok $p->users->update( data => { location => "somewhere $$" } )->success, 'Pithub::Users->update successful';

        # Pithub::Users->update
        is $p->users->get->content->{location}, "somewhere $$", 'Pithub::Users->get location successful after update';
    }

    {

        # Pithub::Users::Followers->list
        ok $p->users->followers->list( user => 'plu' )->count >= 30, 'Pithub::Users::Followers->list count';

        # Pithub::Users::Followers->list_following
        ok $p->users->followers->list_following( user => 'plu' )->count >= 30, 'Pithub::Users::Followers->list_following count';

        # Pithub::Users::Followers->list
        ok $p->users->followers->list->count >= 0, 'Pithub::Users::Followers->list count authenticated user';

        # Pithub::Users::Followers->list_following
        is $p->users->followers->list_following->count, 0, 'Pithub::Users::Followers->list_following count authenticated user';

        # Pithub::Users::Followers->is_following
        ok !$p->users->followers->is_following( user => 'plu' )->success, 'Pithub::Users::Followers->is_following not successful yet';

        # Pithub::Users::Followers->follow
        ok $p->users->followers->follow( user => 'plu' )->success, 'Pithub::Users::Followers->follow successful';

        # Pithub::Users::Followers->list_following
        is $p->users->followers->list_following->count, 1, 'Pithub::Users::Followers->list_following authenticated user now following one user';

        # Pithub::Users::Followers->is_following
        ok $p->users->followers->is_following( user => 'plu' )->success, 'Pithub::Users::Followers->is_following successful now';

        # Pithub::Users::Followers->unfollow
        ok $p->users->followers->unfollow( user => 'plu' )->success, 'Pithub::Users::Followers->unfollow successful';

        # Pithub::Users::Followers->is_following
        ok !$p->users->followers->is_following( user => 'plu' )->success, 'Pithub::Users::Followers->is_following not successful anymore';
    }
}

done_testing;
