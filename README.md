[![codecov](https://codecov.io/gh/plu/Pithub/branch/master/graph/badge.svg)](https://codecov.io/gh/plu/Pithub)
[![CPAN Cover Status](https://cpancoverbadge.perl-services.de/Pithub-0.01040)](https://cpancoverbadge.perl-services.de/Pithub-0.01040)
[![Kwalitee status](https://cpants.cpanauthors.org/dist/Pithub.png)](https://cpants.cpanauthors.org/dist/Pithub)
[![Actions Status](https://github.com/plu/Pithub/actions/workflows/test.yml/badge.svg)](https://github.com/plu/Pithub/actions)
[![Cpan license](https://img.shields.io/cpan/l/Pithub.svg)](https://metacpan.org/release/Pithub)
[![Cpan version](https://img.shields.io/cpan/v/Pithub.svg)](https://metacpan.org/release/Pithub)

# NAME

Pithub - Github v3 API

# VERSION

version 0.01040

# SYNOPSIS

    use Pithub ();

    my $p = Pithub->new;
    # my $p = Pithub->new(utf8 => 0); # enable compatibility options for version 0.01029 or lower
    my $repo = $p->repos->get( user => 'plu', repo => 'Pithub' );

    # $repo->content is either an arrayref or an hashref
    # depending on the API call that has been made
    printf "%s\n", $repo->content->{html_url};     # prints https://github.com/plu/Pithub
    printf "%s\n", $repo->content->{clone_url};    # prints https://github.com/plu/Pithub.git

    # if the result is an arrayref, you can use the result iterator
    my $repos = $p->repos->list( user => 'plu' );
    while ( my $row = $repos->next ) {
        printf "%s\n", $row->{name};
    }

    # Connect to your local GitHub Enterprise instance
    my $ghe_p = Pithub->new(
        api_uri => 'https://github.yourdomain.com/api/v3/'
    );

    # No need to provide user/repo to each module:
    my $pit = Pithub->new(
      user  => 'plu',
      repo  => 'pithub',
      token => 'my_oauth_token',
    );

    $pit->repos->get;
    $pit->repos->commits->list;

    # Use a caching UserAgent
    use CHI                    ();
    use Pithub::Repos          ();
    use WWW::Mechanize::Cached ();

    my $cache = CHI->new(
        driver   => 'File',
        root_dir => '/tmp/pithub-example'
    );

    my $mech = WWW::Mechanize::Cached->new( cache => $cache );

    my $cached_pithub = Pithub::Repos->new(
        auto_pagination => 1,
        per_page        => 100,
        ua              => $mech,
    );

# DESCRIPTION

[Pithub](https://metacpan.org/pod/Pithub) (**P**erl + G**ithub**) provides a set of modules to access the
[Github v3 API](http://developer.github.com/v3/) in an object
oriented way. There is also [Net::GitHub](https://metacpan.org/pod/Net%3A%3AGitHub) which does the same for
all the versions (v1, v2, v3) of the Github API.
[Pithub](https://metacpan.org/pod/Pithub) supports all API calls so far, but only for v3.

# ATTRIBUTES

## search\_api

    my $p = Pithub->new({ search_api => 'v3' });
    my $search = $p->search; # $search->isa('Pithub::SearchV3');

This attribute allows the default for the API to use for searches to be
specified. The two accepted values are `v3` and `legacy`. For compatibility
reasons the default is `legacy`.

# METHODS

## events

Provides access to [Pithub::Events](https://metacpan.org/pod/Pithub%3A%3AEvents).

## gists

Provides access to [Pithub::Gists](https://metacpan.org/pod/Pithub%3A%3AGists).

## git\_data

Provides access to [Pithub::GitData](https://metacpan.org/pod/Pithub%3A%3AGitData).

## issues

Provides access to [Pithub::Issues](https://metacpan.org/pod/Pithub%3A%3AIssues).

## markdown

Provides access to [Pithub::Markdown](https://metacpan.org/pod/Pithub%3A%3AMarkdown).

## orgs

Provides access to [Pithub::Orgs](https://metacpan.org/pod/Pithub%3A%3AOrgs).

## pull\_requests

Provides access to [Pithub::PullRequests](https://metacpan.org/pod/Pithub%3A%3APullRequests).

## repos

Provides access to [Pithub::Repos](https://metacpan.org/pod/Pithub%3A%3ARepos).

## search

    my $legacy_search  = $p->search(search_api => 'legacy');
    my $v3_search      = $p->search(search_api => 'v3');
    my $default_search = $p->search;

Provides access to [Pithub::Search](https://metacpan.org/pod/Pithub%3A%3ASearch) and [Pithub::SearchV3](https://metacpan.org/pod/Pithub%3A%3ASearchV3). When no
`search_api` option is given, the value provided by the `search_api`
attribute is used.

## users

Provides access to [Pithub::Users](https://metacpan.org/pod/Pithub%3A%3AUsers).

# DOCUMENTATION

Quite a lot of the [Pithub](https://metacpan.org/pod/Pithub) documentation has been taken directly
from the great API documentation at
[Github](http://developer.github.com/v3/). Please also read the
documentation there, since it might be more complete and more
up-to-date.

[Pithub::Base](https://metacpan.org/pod/Pithub%3A%3ABase) contains documentation for attributes inherited by all
Pithub modules.

# WARNING

[Pithub](https://metacpan.org/pod/Pithub) as well as the
[Github v3 API](http://developer.github.com/v3/) are still under
development. So there might be things broken on both sides. Besides
that it's possible that the API will change. This applies to
[Pithub](https://metacpan.org/pod/Pithub) itself as well as the
[Github v3 API](http://developer.github.com/v3/).

# CONTRIBUTE

This module is hosted on [Github](https://github.com/plu/Pithub), so
feel free to fork it and send pull requests.
There are two different kinds of test suites, one is just checking
the HTTP requests that are created by the method calls, without
actually sending them. The second one is sending real requests to
the Github API. If you want to contribute to this project, I highly
recommend to run the live tests on a test account, because it will
generate a lot of activity.

# MODULES

There are different ways of using the Pithub library. You can either
use the main module [Pithub](https://metacpan.org/pod/Pithub) to get access to all other
modules, like [Pithub::Repos](https://metacpan.org/pod/Pithub%3A%3ARepos) for example. Or you can use
[Pithub::Repos](https://metacpan.org/pod/Pithub%3A%3ARepos) directly and create an instance of it. All
modules accept the same [attributes](https://metacpan.org/pod/Pithub%3A%3ABase#ATTRIBUTES),
either in the constructor or later by calling the setters.

Besides that there are other modules involved. Every method call
which maps directly to a Github API call returns a
[Pithub::Result](https://metacpan.org/pod/Pithub%3A%3AResult) object. This contains everything interesting
about the response returned from the API call.

[Pithub::Base](https://metacpan.org/pod/Pithub%3A%3ABase) might be interesting for two reasons:

- The list of [attributes](https://metacpan.org/pod/Pithub%3A%3ABase#ATTRIBUTES) which all modules
accept.
- The [request](https://metacpan.org/pod/Pithub%3A%3ABase#request) method: In case Github adds a
new API call which is not supported yet by [Pithub](https://metacpan.org/pod/Pithub) the
[request](https://metacpan.org/pod/Pithub%3A%3ABase#request) method can be used directly to
perform this new API call, there's some documentation on how to
use it.
    - [Pithub::Events](https://metacpan.org/pod/Pithub%3A%3AEvents)

        See also: [http://developer.github.com/v3/events/](http://developer.github.com/v3/events/)

            my $events = Pithub->new->events;
            my $events = Pithub::Events->new;

    - [Pithub::Gists](https://metacpan.org/pod/Pithub%3A%3AGists)

        See also: [http://developer.github.com/v3/gists/](http://developer.github.com/v3/gists/)

            my $gists = Pithub->new->gists;
            my $gists = Pithub::Gists->new;

        - [Pithub::Gists::Comments](https://metacpan.org/pod/Pithub%3A%3AGists%3A%3AComments)

            See also: [http://developer.github.com/v3/gists/comments/](http://developer.github.com/v3/gists/comments/)

                my $comments = Pithub->new->gists->comments;
                my $comments = Pithub::Gists->new->comments;
                my $comments = Pithub::Gists::Comments->new;

    - [Pithub::GitData](https://metacpan.org/pod/Pithub%3A%3AGitData)

        See also: [http://developer.github.com/v3/git/](http://developer.github.com/v3/git/)

            my $git_data = Pithub->new->git_data;
            my $git_data = Pithub::GitData->new;

        - [Pithub::GitData::Blobs](https://metacpan.org/pod/Pithub%3A%3AGitData%3A%3ABlobs)

            See also: [http://developer.github.com/v3/git/blobs/](http://developer.github.com/v3/git/blobs/)

                my $blobs = Pithub->new->git_data->blobs;
                my $blobs = Pithub::GitData->new->blobs;
                my $blobs = Pithub::GitData::Blobs->new;

        - [Pithub::GitData::Commits](https://metacpan.org/pod/Pithub%3A%3AGitData%3A%3ACommits)

            See also: [http://developer.github.com/v3/git/commits/](http://developer.github.com/v3/git/commits/)

                my $commits = Pithub->new->git_data->commits;
                my $commits = Pithub::GitData->new->commits;
                my $commits = Pithub::GitData::Commits->new;

        - [Pithub::GitData::References](https://metacpan.org/pod/Pithub%3A%3AGitData%3A%3AReferences)

            See also: [http://developer.github.com/v3/git/refs/](http://developer.github.com/v3/git/refs/)

                my $references = Pithub->new->git_data->references;
                my $references = Pithub::GitData->new->references;
                my $references = Pithub::GitData::References->new;

        - [Pithub::GitData::Tags](https://metacpan.org/pod/Pithub%3A%3AGitData%3A%3ATags)

            See also: [http://developer.github.com/v3/git/tags/](http://developer.github.com/v3/git/tags/)

                my $tags = Pithub->new->git_data->tags;
                my $tags = Pithub::GitData->new->tags;
                my $tags = Pithub::GitData::Tags->new;

        - [Pithub::GitData::Trees](https://metacpan.org/pod/Pithub%3A%3AGitData%3A%3ATrees)

            See also: [http://developer.github.com/v3/git/trees/](http://developer.github.com/v3/git/trees/)

                my $trees = Pithub->new->git_data->trees;
                my $trees = Pithub::GitData->new->trees;
                my $trees = Pithub::GitData::Trees->new;

    - [Pithub::Issues](https://metacpan.org/pod/Pithub%3A%3AIssues)

        See also: [http://developer.github.com/v3/issues/](http://developer.github.com/v3/issues/)

            my $issues = Pithub->new->issues;
            my $issues = Pithub::Issues->new;

        - [Pithub::Issues::Assignees](https://metacpan.org/pod/Pithub%3A%3AIssues%3A%3AAssignees)

            See also: [http://developer.github.com/v3/issues/assignees/](http://developer.github.com/v3/issues/assignees/)

                my $assignees = Pithub->new->issues->assignees;
                my $assignees = Pithub::Issues->new->assignees;
                my $assignees = Pithub::Issues::Assignees->new;

        - [Pithub::Issues::Comments](https://metacpan.org/pod/Pithub%3A%3AIssues%3A%3AComments)

            See also: [http://developer.github.com/v3/issues/comments/](http://developer.github.com/v3/issues/comments/)

                my $comments = Pithub->new->issues->comments;
                my $comments = Pithub::Issues->new->comments;
                my $comments = Pithub::Issues::Comments->new;

        - [Pithub::Issues::Events](https://metacpan.org/pod/Pithub%3A%3AIssues%3A%3AEvents)

            See also: [http://developer.github.com/v3/issues/events/](http://developer.github.com/v3/issues/events/)

                my $events = Pithub->new->issues->events;
                my $events = Pithub::Issues->new->events;
                my $events = Pithub::Issues::Events->new;

        - [Pithub::Issues::Labels](https://metacpan.org/pod/Pithub%3A%3AIssues%3A%3ALabels)

            See also: [http://developer.github.com/v3/issues/labels/](http://developer.github.com/v3/issues/labels/)

                my $labels = Pithub->new->issues->labels;
                my $labels = Pithub::Issues->new->labels;
                my $labels = Pithub::Issues::Labels->new;

        - [Pithub::Issues::Milestones](https://metacpan.org/pod/Pithub%3A%3AIssues%3A%3AMilestones)

            See also: [http://developer.github.com/v3/issues/milestones/](http://developer.github.com/v3/issues/milestones/)

                my $milestones = Pithub->new->issues->milestones;
                my $milestones = Pithub::Issues->new->milestones;
                my $milestones = Pithub::Issues::Milestones->new;

    - [Pithub::Orgs](https://metacpan.org/pod/Pithub%3A%3AOrgs)

        See also: [http://developer.github.com/v3/orgs/](http://developer.github.com/v3/orgs/)

            my $orgs = Pithub->new->orgs;
            my $orgs = Pithub::Orgs->new;

        - [Pithub::Orgs::Members](https://metacpan.org/pod/Pithub%3A%3AOrgs%3A%3AMembers)

            See also: [http://developer.github.com/v3/orgs/members/](http://developer.github.com/v3/orgs/members/)

                my $members = Pithub->new->orgs->members;
                my $members = Pithub::Orgs->new->members;
                my $members = Pithub::Orgs::Members->new;

        - [Pithub::Orgs::Teams](https://metacpan.org/pod/Pithub%3A%3AOrgs%3A%3ATeams)

            See also: [http://developer.github.com/v3/orgs/teams/](http://developer.github.com/v3/orgs/teams/)

                my $teams = Pithub->new->orgs->teams;
                my $teams = Pithub::Orgs->new->teams;
                my $teams = Pithub::Orgs::Teams->new;

    - [Pithub::PullRequests](https://metacpan.org/pod/Pithub%3A%3APullRequests)

        See also: [http://developer.github.com/v3/pulls/](http://developer.github.com/v3/pulls/)

            my $pull_requests = Pithub->new->pull_requests;
            my $pull_requests = Pithub::PullRequests->new;

        - [Pithub::PullRequests::Comments](https://metacpan.org/pod/Pithub%3A%3APullRequests%3A%3AComments)

            See also: [http://developer.github.com/v3/pulls/comments/](http://developer.github.com/v3/pulls/comments/)

                my $comments = Pithub->new->pull_requests->comments;
                my $comments = Pithub::PullRequests->new->comments;
                my $comments = Pithub::PullRequests::Comments->new;

        - [Pithub::PullRequests::Reviewers](https://metacpan.org/pod/Pithub%3A%3APullRequests%3A%3AReviewers)

            See also: [https://docs.github.com/en/rest/reference/pulls#review-requests](https://docs.github.com/en/rest/reference/pulls#review-requests)

                my $reviewers = Pithub->new->pull_requests->reviewers;
                my $reviewers = Pithub::PullRequests->new->reviewers;
                my $reviewers = Pithub::PullRequests::Reviewers->new;

    - [Pithub::Repos](https://metacpan.org/pod/Pithub%3A%3ARepos)

        See also: [http://developer.github.com/v3/repos/](http://developer.github.com/v3/repos/)

            my $repos = Pithub->new->repos;
            my $repos = Pithub::Repos->new;

        - [Pithub::Repos::Collaborators](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3ACollaborators)

            See also: [http://developer.github.com/v3/repos/collaborators/](http://developer.github.com/v3/repos/collaborators/)

                my $collaborators = Pithub->new->repos->collaborators;
                my $collaborators = Pithub::Repos->new->collaborators;
                my $collaborators = Pithub::Repos::Collaborators->new;

        - [Pithub::Repos::Commits](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3ACommits)

            See also: [http://developer.github.com/v3/repos/commits/](http://developer.github.com/v3/repos/commits/)

                my $commits = Pithub->new->repos->commits;
                my $commits = Pithub::Repos->new->commits;
                my $commits = Pithub::Repos::Commits->new;

        - [Pithub::Repos::Contents](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AContents)

            See also: [http://developer.github.com/v3/repos/contents/](http://developer.github.com/v3/repos/contents/)

                my $contents = Pithub->new->repos->contents;
                my $contents = Pithub::Repos->new->contents;
                my $contents = Pithub::Repos::Contents->new;

        - [Pithub::Repos::Downloads](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3ADownloads)

            Github says: The Downloads API (described below) was deprecated on
            December 11, 2012. It will be removed at a future date. We recommend
            using [Pithub::Repos::Releases](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AReleases) instead.

            See also: [http://developer.github.com/v3/repos/downloads/](http://developer.github.com/v3/repos/downloads/)

                my $downloads = Pithub->new->repos->downloads;
                my $downloads = Pithub::Repos->new->downloads;
                my $downloads = Pithub::Repos::Downloads->new;

        - [Pithub::Repos::Forks](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AForks)

            See also: [http://developer.github.com/v3/repos/forks/](http://developer.github.com/v3/repos/forks/)

                my $forks = Pithub->new->repos->forks;
                my $forks = Pithub::Repos->new->forks;
                my $forks = Pithub::Repos::Forks->new;

        - [Pithub::Repos::Keys](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AKeys)

            See also: [http://developer.github.com/v3/repos/keys/](http://developer.github.com/v3/repos/keys/)

                my $keys = Pithub->new->repos->keys;
                my $keys = Pithub::Repos->new->keys;
                my $keys = Pithub::Repos::Keys->new;

        - [Pithub::Repos::Releases](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AReleases)

            See also: [http://developer.github.com/v3/repos/releases/](http://developer.github.com/v3/repos/releases/)

                my $releases = Pithub->new->repos->releases;
                my $releases = Pithub::Repos->new->releases;
                my $releases = Pithub::Repos::Releases->new;

            - [Pithub::Repos::Releases::Assets](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AReleases%3A%3AAssets)

                See also: [http://developer.github.com/v3/repos/releases/](http://developer.github.com/v3/repos/releases/)

                    my $assets = Pithub->new->repos->releases->assets;
                    my $assets = Pithub::Repos->new->releases->assets;
                    my $assets = Pithub::Repos::Releases->new->assets;
                    my $assets = Pithub::Repos::Releases::Assets->new;

        - [Pithub::Repos::Stats](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AStats)

            See also: [http://developer.github.com/v3/repos/statistics/](http://developer.github.com/v3/repos/statistics/)

                my $watching = Pithub->new->repos->stats;
                my $watching = Pithub::Repos->new->stats;
                my $watching = Pithub::Repos::Stats->new;

        - [Pithub::Repos::Statuses](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AStatuses)

            See also: [http://developer.github.com/v3/repos/statuses/](http://developer.github.com/v3/repos/statuses/)

                my $watching = Pithub->new->repos->statuses;
                my $watching = Pithub::Repos->new->statuses;
                my $watching = Pithub::Repos::Statuses->new;

        - [Pithub::Repos::Watching](https://metacpan.org/pod/Pithub%3A%3ARepos%3A%3AWatching)

            See also: [http://developer.github.com/v3/repos/watching/](http://developer.github.com/v3/repos/watching/)

                my $watching = Pithub->new->repos->watching;
                my $watching = Pithub::Repos->new->watching;
                my $watching = Pithub::Repos::Watching->new;

    - [Pithub::Users](https://metacpan.org/pod/Pithub%3A%3AUsers)

        See also: [http://developer.github.com/v3/users/](http://developer.github.com/v3/users/)

            my $users = Pithub->new->users;
            my $users = Pithub::Users->new;

        - [Pithub::Users::Emails](https://metacpan.org/pod/Pithub%3A%3AUsers%3A%3AEmails)

            See also: [http://developer.github.com/v3/users/emails/](http://developer.github.com/v3/users/emails/)

                my $emails = Pithub->new->users->emails;
                my $emails = Pithub::Users->new->emails;
                my $emails = Pithub::Users::Emails->new;

        - [Pithub::Users::Followers](https://metacpan.org/pod/Pithub%3A%3AUsers%3A%3AFollowers)

            See also: [http://developer.github.com/v3/users/followers/](http://developer.github.com/v3/users/followers/)

                my $followers = Pithub->new->users->followers;
                my $followers = Pithub::Users->new->followers;
                my $followers = Pithub::Users::Followers->new;

        - [Pithub::Users::Keys](https://metacpan.org/pod/Pithub%3A%3AUsers%3A%3AKeys)

            See also: [http://developer.github.com/v3/users/keys/](http://developer.github.com/v3/users/keys/)

                my $keys = Pithub->new->users->keys;
                my $keys = Pithub::Users->new->keys;
                my $keys = Pithub::Users::Keys->new;

# CONTRIBUTORS

- Andreas Marienborg
- Alessandro Ghedini
- Michael G Schwern

# AUTHOR

Johannes Plunien <plu@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
