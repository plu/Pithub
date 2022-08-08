#!perl

use strict;
use warnings;

use Pithub            ();
use Test::Differences qw( eq_or_diff );
use Test::More import => [qw( done_testing is like ok skip $TODO )];

SKIP: {
    skip 'Set PITHUB_TEST_LIVE to true to run these tests', 1
        unless $ENV{PITHUB_TEST_LIVE};

    my $p      = Pithub->new;
    my $result = $p->request(
        method => 'GET',
        path   => '/'
    );

    is $result->code,    200, 'HTTP status is 200';
    is $result->success, 1,   'Successful';

    {
        local $TODO = 'Not sure why this is failing';
        like $result->etag, qr{^"[a-f0-9]+"$}, 'ETag';
    }

    my $base_url = 'https://api.github.com';
    eq_or_diff(
        $result->content,
        {
            authorizations_url => "$base_url/authorizations",
            code_search_url    =>
                "$base_url/search/code?q={query}{&page,per_page,sort,order}",
            commit_search_url =>
                "$base_url/search/commits?q={query}{&page,per_page,sort,order}",
            current_user_authorizations_html_url =>
                'https://github.com/settings/connections/applications{/client_id}',
            current_user_repositories_url =>
                "$base_url/user/repos{?type,page,per_page,sort}",
            current_user_url => "$base_url/user",
            emails_url       => "$base_url/user/emails",
            emojis_url       => "$base_url/emojis",
            events_url       => "$base_url/events",
            feeds_url        => "$base_url/feeds",
            followers_url    => "$base_url/user/followers",
            following_url    => "$base_url/user/following{/target}",
            gists_url        => "$base_url/gists{/gist_id}",
            hub_url          => "$base_url/hub",
            issue_search_url =>
                "$base_url/search/issues?q={query}{&page,per_page,sort,order}",
            issues_url       => "$base_url/issues",
            keys_url         => "$base_url/user/keys",
            label_search_url =>
                "$base_url/search/labels?q={query}&repository_id={repository_id}{&page,per_page}",
            notifications_url             => "$base_url/notifications",
            organization_repositories_url =>
                "$base_url/orgs/{org}/repos{?type,page,per_page,sort}",
            organization_teams_url => "$base_url/orgs/{org}/teams",
            organization_url       => "$base_url/orgs/{org}",
            public_gists_url       => "$base_url/gists/public",
            rate_limit_url         => "$base_url/rate_limit",
            repository_search_url  =>
                "$base_url/search/repositories?q={query}{&page,per_page,sort,order}",
            repository_url    => "$base_url/repos/{owner}/{repo}",
            starred_gists_url => "$base_url/gists/starred",
            starred_url       => "$base_url/user/starred{/owner}{/repo}",
            topic_search_url  =>
                "$base_url/search/topics?q={query}{&page,per_page}",
            user_organizations_url => "$base_url/user/orgs",
            user_repositories_url  =>
                "$base_url/users/{user}/repos{?type,page,per_page,sort}",
            user_search_url =>
                "$base_url/search/users?q={query}{&page,per_page,sort,order}",
            user_url => "$base_url/users/{user}",
        },
        'Empty response'
    );
}

# These tests may break very easily because data on Github can and will change, of course.
# And they also might fail once the ratelimit has been reached.
SKIP: {
    skip 'Set PITHUB_TEST_LIVE_DATA to true to run these tests', 1
        unless $ENV{PITHUB_TEST_LIVE_DATA};

    my $p = Pithub->new;

    # Pagination + per_page
    {
        my $g = Pithub::Gists->new( per_page => 2 );

        my @seen = ();

        my $test = sub {
            my ( $row, $seen ) = @_;
            my $verb = $seen ? 'did' : 'did not';
            my $id   = $row->{id};
            ok $id, "Pithub::Gists->list found gist id ${id}";
            is grep( $_ eq $id, @seen ), $seen,
                "Pithub::Gists->list we ${verb} see id ${id}";
            push @seen, $id;
        };

        my $result = $g->list( public => 1 );
        is $result->success, 1, 'Pithub::Gists->list successful';
        is $result->count,   2, 'The per_page setting was successful';

        foreach my $page ( 1 .. 2 ) {
            while ( my $row = $result->next ) {
                $test->( $row, 0 );
            }
            $result = $result->next_page unless $page == 2;
        }

        # Browse to the last page and see if we can get some gist id's there
        $result = $result->last_page;
        while ( my $row = $result->next ) {
            $test->( $row, 0 );
        }

        # Browse to the previous page and see if we can get some gist id's there
        $result = $result->prev_page;
        while ( my $row = $result->next ) {
            $test->( $row, 0 );
        }

        # Browse to the first page and see if we can get some gist id's there
        $result = $result->first_page;
        while ( my $row = $result->next ) {
            $test->( $row, 1 );    # we saw those gists already!
        }
    }
}

done_testing;

# TODO: implement tests for following methods:

# Pithub::GitData::References->create

# Pithub::GitData::Tags->get
# Pithub::GitData::Tags->create

# Pithub::Gists->fork

# Pithub::Issues::Events->get
# Pithub::Issues::Events->list

# Pithub::Orgs::Members->delete

# Pithub::PullRequests->merge

# Pithub::PullRequests::Comments->create
# Pithub::PullRequests::Comments->delete
# Pithub::PullRequests::Comments->get
# Pithub::PullRequests::Comments->list
# Pithub::PullRequests::Comments->update

# Pithub::Repos->teams
