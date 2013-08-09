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

    # Pithub::Orgs->get
    {
        my $result = $p->orgs->get( org => 'CPAN-API' );
        is $result->success, 1, 'Pithub::Orgs->get successful';
        is $result->content->{type},  'Organization', 'Pithub::Orgs->get: Attribute type';
        is $result->content->{login}, 'CPAN-API',     'Pithub::Orgs->get: Attribute login';
        is $result->content->{name},  'MetaCPAN',     'Pithub::Orgs->get: Attribute name';
        is $result->content->{id},    460239,         'Pithub::Orgs->get: Attribute id';
    }

    # Pithub::Orgs->list
    {
        my $result = $p->orgs->list( user => 'plu' );
        is $result->success, 1, 'Pithub::Orgs->list successful';
        is $result->content->[1]{login}, 'CPAN-API', 'Pithub::Orgs->get: Attribute login';
        is $result->content->[1]{id},    460239,     'Pithub::Orgs->get: Attribute id';
    }

    # Pithub::Orgs::Members->list_public
    {
        my $result = $p->orgs->members->list_public( org => 'CPAN-API' );
        is $result->success, 1, 'Pithub::Orgs::Members->list_public successful';
        ok $result->count > 0, 'Pithub::Orgs::Members->list_public has some rows';
        while ( my $row = $result->next ) {
            ok $row->{id},    "Pithub::Orgs::Members->list_public: Attribute id ($row->{id})";
            ok $row->{login}, "Pithub::Orgs::Members->list_public: Attribute login ($row->{login})";
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

        # Pithub::Orgs->update
        ok $p->orgs->update(
            org  => $org,
            data => { location => "somewhere $$" }
          )->success,
          'Pithub::Orgs->update successful';

        # Pithub::Orgs->get
        is $p->orgs->get( org => $org )->content->{location}, "somewhere $$", 'Pithub::Orgs->get location after update';

        # Pithub::Orgs::Members->is_member
        ok $p->orgs->members->is_member(
            org  => $org,
            user => $user,
        )->success, 'Pithub::Orgs::Members->is_member successful';

        # Pithub::Orgs::Members->conceal
        ok $p->orgs->members->conceal(
            org  => $org,
            user => $user,
        )->success, 'Pithub::Orgs::Members->conceal successful';

        # Pithub::Orgs::Members->is_public
        ok !$p->orgs->members->is_public(
            org  => $org,
            user => $user,
        )->success, 'Pithub::Orgs::Members->is_public not successful after conceal';

        # Pithub::Orgs::Members->list_public
        is $p->orgs->members->list_public(
            org  => $org,
            user => $user,
        )->count, 0, 'Pithub::Orgs::Members->list_public no public members';

        # Pithub::Orgs::Members->publicize
        ok $p->orgs->members->publicize(
            org  => $org,
            user => $user,
        )->success, 'Pithub::Orgs::Members->publicize successful';

        # Pithub::Orgs::Members->list_public
        is $p->orgs->members->list_public(
            org  => $org,
            user => $user,
        )->count, 1, 'Pithub::Orgs::Members->list_public one public member after publicize';

        # Pithub::Orgs::Members->is_public
        ok $p->orgs->members->is_public(
            org  => $org,
            user => $user,
        )->success, 'Pithub::Orgs::Members->is_public successful after publicize';

        # Pithub::Orgs::Members->list
        is $p->orgs->members->list(
            org  => $org,
            user => $user,
        )->count, 1, 'Pithub::Orgs::Members->list one member';

        # Pithub::Orgs::Teams->create
        my $team_id = $p->orgs->teams->create(
            org  => $org,
            data => { name => 'Core' }
        )->content->{id};
        like $team_id, qr{^\d+$}, 'Pithub::Orgs::Teams->create successful, returned team id';

        # Pithub::Orgs::Teams->list
        my @teams = splice @{ $p->orgs->teams->list( org => $org )->content }, 0, 2;
        eq_or_diff [ map { $_->{name} } @teams ], [qw(Core Owners)], 'Pithub::Orgs::Teams->list after create';

        # Pithub::Orgs::Teams->update
        ok $p->orgs->teams->update(
            team_id => $team_id,
            data    => { name => 'CoreTeam' },
        )->success, 'Pithub::Orgs::Teams->update successful';

        # Pithub::Orgs::Teams->get
        is $p->orgs->teams->get( team_id => $team_id )->content->{name}, 'CoreTeam', 'Pithub::Orgs::Teams->get after update';

        # Pithub::Orgs::Teams->is_member
        ok !$p->orgs->teams->is_member(
            team_id => $team_id,
            user    => $user,
        )->success, 'Pithub::Orgs::Teams->is_member not successful yet';

        # Pithub::Orgs::Teams->add_member
        ok $p->orgs->teams->add_member(
            team_id => $team_id,
            user    => $user,
        )->success, 'Pithub::Orgs::Teams->add_member successful';

        # Pithub::Orgs::Teams->is_member
        ok $p->orgs->teams->is_member(
            team_id => $team_id,
            user    => $user,
        )->success, 'Pithub::Orgs::Teams->is_member successful after add_member';

        # Pithub::Orgs::Teams->list_members
        is $p->orgs->teams->list_members( team_id => $team_id )->first->{login}, $user, 'Pithub::Orgs::Teams->list_members after add_member';

        # Pithub::Orgs::Teams->remove_member
        ok $p->orgs->teams->remove_member(
            team_id => $team_id,
            user    => $user,
        )->success, 'Pithub::Orgs::Teams->remove_member successful';

        # Pithub::Orgs::Teams->is_member
        ok !$p->orgs->teams->is_member(
            team_id => $team_id,
            user    => $user,
        )->success, 'Pithub::Orgs::Teams-is_member not successful after remove_member';

        # Pithub::Orgs::Teams->has_repo
        ok !$p->orgs->teams->has_repo(
            team_id => $team_id,
            repo    => "${org}/${org_repo}",
        )->success, 'Pithub::Orgs::Teams->has_repo not successful yet';

        # Pithub::Orgs::Teams->add_repo
        ok $p->orgs->teams->add_repo(
            team_id => $team_id,
            repo    => "${org}/${org_repo}",
        )->success, 'Pithub::Orgs::Teams->add_repo successful';

        # Pithub::Orgs::Teams->has_repo
        ok $p->orgs->teams->has_repo(
            team_id => $team_id,
            repo    => "${org}/${org_repo}",
        )->success, 'Pithub::Orgs::Teams->has_repo successful after add_repo';

        # Pithub::Orgs::Teams->list_repos
        is $p->orgs->teams->list_repos( team_id => $team_id )->count, 1, 'Pithub::Orgs::Teams->list_repos one repo';

        # Pithub::Orgs::Teams->remove_repo
        ok $p->orgs->teams->remove_repo(
            team_id => $team_id,
            repo    => "${org}/${org_repo}",
        )->success, 'Pithub::Orgs::Teams->remove_repo successful';

        # Pithub::Orgs::Teams->has_repo
        ok !$p->orgs->teams->has_repo(
            team_id => $team_id,
            repo    => "${org}/${org_repo}",
        )->success, 'Pithub::Orgs::Teams->has_repo not successful after remove_repo';

        # Pithub::Orgs::Teams->delete
        ok $p->orgs->teams->delete( team_id => $team_id )->success, 'Pithub::Orgs::Teams->delete successful';

        # Pithub::Orgs::Teams->get
        ok !$p->orgs->teams->get( team_id => $team_id )->success, 'Pithub::Orgs::Teams->get not successful after delete';
    }
}

done_testing;
