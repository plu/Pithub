package Pithub;

# ABSTRACT: Github v3 API

use Moo;
use Pithub::Events;
use Pithub::Gists;
use Pithub::GitData;
use Pithub::Issues;
use Pithub::Orgs;
use Pithub::PullRequests;
use Pithub::Repos;
use Pithub::Search;
use Pithub::Users;
extends 'Pithub::Base';

=head1 DESCRIPTION

L<Pithub> provides a set of modules to access the
L<Github v3 API|http://developer.github.com/v3/> in an object
oriented way. There is also L<Net::GitHub> which does the same for
all the versions (v1, v2, v3) of the Github API.
L<Pithub> supports all API calls so far, but only for v3.

=head1 SYNOPSIS

    use Pithub;
    use Data::Dumper;

    my $p = Pithub->new;
    my $result = $p->repos->get( user => 'plu', repo => 'Pithub' );

    # $result->content is either an arrayref or an hashref
    # depending on the API call that has been made
    printf "%s\n", $result->content->{html_url};     # prints https://github.com/plu/Pithub
    printf "%s\n", $result->content->{clone_url};    # prints https://github.com/plu/Pithub.git

    # if the result is an arrayref, you can use the result iterator
    my $result = $p->repos->list( user => 'plu' );
    while ( my $row = $result->next ) {
        printf "%s\n", $row->{name};
    }

=head1 DOCUMENTATION

Quite a lot of the L<Pithub> documentation has been taken directly
from the great API documentation at
L<Github|http://developer.github.com/v3/>. Please also read the
documentation there, since it might be more complete and more
up-to-date.

=head1 WARNING

L<Pithub> as well as the
L<Github v3 API|http://developer.github.com/v3/> are still under
development. So there might be things broken on both sides. Besides
that it's possible that the API will change. This applies to
L<Pithub> itself as well as the
L<Github v3 API|http://developer.github.com/v3/>.

=head1 CONTRIBUTE

This module is hosted on L<Github|https://github.com/plu/Pithub>, so
feel free to fork it and send pull requests.
There are two different kinds of test suites, one is just checking
the HTTP requests that are created by the method calls, without
actually sending them. The second one is sending real requests to
the Github API. If you want to contribute to this project, I highly
recommend to run the live tests on a test account, because it will
generate a lof of activity.

=head1 MODULES

There are different ways of using the Pithub library. You can either
use the main module L<Pithub> to get access to all other
modules, like L<Pithub::Repos> for example. Or you can use
L<Pithub::Repos> directly and create an instance of it. All
modules accept the same L<attributes|Pithub::Base/ATTRIBUTES>,
either in the constructor or later by calling the setters.

Besides that there are other modules involved. Every method call
which maps directly to a Github API call returns a
L<Pithub::Result> object. This contains everything interesting
about the response returned from the API call.

L<Pithub::Base> might be interesting for two reasons:

=over

=item *

The list of L<attributes|Pithub::Base/ATTRIBUTES> which all modules
accept.

=item *

The L<request|Pithub::Base/request> method: In case Github adds a
new API call which is not supported yet by L<Pithub> the
L<request|Pithub::Base/request> method can be used directly to
perform this new API call, there's some documentation on how to
use it.

=over

=item *

L<Pithub::Events>

See also: L<http://developer.github.com/v3/events/>

    my $gists = Pithub->new->events;
    my $gists = Pithub::Events->new;

=item *

L<Pithub::Gists>

See also: L<http://developer.github.com/v3/gists/>

    my $gists = Pithub->new->gists;
    my $gists = Pithub::Gists->new;

=over

=item *

L<Pithub::Gists::Comments>

See also: L<http://developer.github.com/v3/gists/comments/>

    my $comments = Pithub->new->gists->comments;
    my $comments = Pithub::Gists->new->comments;
    my $comments = Pithub::Gists::Comments->new;

=back

=back

=over

=item *

L<Pithub::GitData>

See also: L<http://developer.github.com/v3/git/>

    my $git_data = Pithub->new->git_data;
    my $git_data = Pithub::GitData->new;

=over

=item *

L<Pithub::GitData::Blobs>

See also: L<http://developer.github.com/v3/git/blobs/>

    my $blobs = Pithub->new->git_data->blobs;
    my $blobs = Pithub::GitData->new->blobs;
    my $blobs = Pithub::GitData::Blobs->new;

=item *

L<Pithub::GitData::Commits>

See also: L<http://developer.github.com/v3/git/commits/>

    my $commits = Pithub->new->git_data->commits;
    my $commits = Pithub::GitData->new->commits;
    my $commits = Pithub::GitData::Commits->new;

=item *

L<Pithub::GitData::References>

See also: L<http://developer.github.com/v3/git/refs/>

    my $references = Pithub->new->git_data->references;
    my $references = Pithub::GitData->new->references;
    my $references = Pithub::GitData::References->new;

=item *

L<Pithub::GitData::Tags>

See also: L<http://developer.github.com/v3/git/tags/>

    my $tags = Pithub->new->git_data->tags;
    my $tags = Pithub::GitData->new->tags;
    my $tags = Pithub::GitData::Tags->new;

=item *

L<Pithub::GitData::Trees>

See also: L<http://developer.github.com/v3/git/trees/>

    my $trees = Pithub->new->git_data->trees;
    my $trees = Pithub::GitData->new->trees;
    my $trees = Pithub::GitData::Trees->new;

=back

=back

=over

=item *

L<Pithub::Issues>

See also: L<http://developer.github.com/v3/issues/>

    my $issues = Pithub->new->issues;
    my $issues = Pithub::Issues->new;

=over

=item *

L<Pithub::Issues::Assignees>

See also: L<http://developer.github.com/v3/issues/assignees/>

    my $assignees = Pithub->new->issues->assignees;
    my $assignees = Pithub::Issues->new->assignees;
    my $assignees = Pithub::Issues::Assignees->new;

=item *

L<Pithub::Issues::Comments>

See also: L<http://developer.github.com/v3/issues/comments/>

    my $comments = Pithub->new->issues->comments;
    my $comments = Pithub::Issues->new->comments;
    my $comments = Pithub::Issues::Comments->new;

=item *

L<Pithub::Issues::Events>

See also: L<http://developer.github.com/v3/issues/events/>

    my $events = Pithub->new->issues->events;
    my $events = Pithub::Issues->new->events;
    my $events = Pithub::Issues::Events->new;

=item *

L<Pithub::Issues::Labels>

See also: L<http://developer.github.com/v3/issues/labels/>

    my $labels = Pithub->new->issues->labels;
    my $labels = Pithub::Issues->new->labels;
    my $labels = Pithub::Issues::Labels->new;

=item *

L<Pithub::Issues::Milestones>

See also: L<http://developer.github.com/v3/issues/milestones/>

    my $milestones = Pithub->new->issues->milestones;
    my $milestones = Pithub::Issues->new->milestones;
    my $milestones = Pithub::Issues::Milestones->new;

=back

=back

=over

=item *

L<Pithub::Orgs>

See also: L<http://developer.github.com/v3/orgs/>

    my $orgs = Pithub->new->orgs;
    my $orgs = Pithub::Orgs->new;

=over

=item *

L<Pithub::Orgs::Members>

See also: L<http://developer.github.com/v3/orgs/members/>

    my $members = Pithub->new->orgs->members;
    my $members = Pithub::Orgs->new->members;
    my $members = Pithub::Orgs::Members->new;

=item *

L<Pithub::Orgs::Teams>

See also: L<http://developer.github.com/v3/orgs/teams/>

    my $teams = Pithub->new->orgs->teams;
    my $teams = Pithub::Orgs->new->teams;
    my $teams = Pithub::Orgs::Teams->new;

=back

=back

=over

=item *

L<Pithub::PullRequests>

See also: L<http://developer.github.com/v3/pulls/>

    my $pull_requests = Pithub->new->pull_requests;
    my $pull_requests = Pithub::PullRequests->new;

=over

=item *

L<Pithub::PullRequests::Comments>

See also: L<http://developer.github.com/v3/pulls/comments/>

    my $comments = Pithub->new->pull_requests->comments;
    my $comments = Pithub::PullRequests->new->comments;
    my $comments = Pithub::PullRequests::Comments->new;

=back

=back

=over

=item *

L<Pithub::Repos>

See also: L<http://developer.github.com/v3/repos/>

    my $repos = Pithub->new->repos;
    my $repos = Pithub::Repos->new;

=over

=item *

L<Pithub::Repos::Collaborators>

See also: L<http://developer.github.com/v3/repos/collaborators/>

    my $collaborators = Pithub->new->repos->collaborators;
    my $collaborators = Pithub::Repos->new->collaborators;
    my $collaborators = Pithub::Repos::Collaborators->new;

=item *

L<Pithub::Repos::Commits>

See also: L<http://developer.github.com/v3/repos/commits/>

    my $commits = Pithub->new->repos->commits;
    my $commits = Pithub::Repos->new->commits;
    my $commits = Pithub::Repos::Commits->new;

=item *

L<Pithub::Repos::Contents>

See also: L<http://developer.github.com/v3/repos/contents/>

    my $contents = Pithub->new->repos->contents;
    my $contents = Pithub::Repos->new->contents;
    my $contents = Pithub::Repos::Contents->new;


=item *

L<Pithub::Repos::Downloads>

Github says: The Downloads API (described below) was deprecated on
December 11, 2012. It will be removed at a future date. We recommend
using L<Pithub::Repos::Releases> instead.

See also: L<http://developer.github.com/v3/repos/downloads/>

    my $downloads = Pithub->new->repos->downloads;
    my $downloads = Pithub::Repos->new->downloads;
    my $downloads = Pithub::Repos::Downloads->new;

=item *

L<Pithub::Repos::Forks>

See also: L<http://developer.github.com/v3/repos/forks/>

    my $forks = Pithub->new->repos->forks;
    my $forks = Pithub::Repos->new->forks;
    my $forks = Pithub::Repos::Forks->new;

=item *

L<Pithub::Repos::Keys>

See also: L<http://developer.github.com/v3/repos/keys/>

    my $keys = Pithub->new->repos->keys;
    my $keys = Pithub::Repos->new->keys;
    my $keys = Pithub::Repos::Keys->new;

=item *

L<Pithub::Repos::Releases>

See also: L<http://developer.github.com/v3/repos/releases/>

    my $releases = Pithub->new->repos->releases;
    my $releases = Pithub::Repos->new->releases;
    my $releases = Pithub::Repos::Releases->new;

=over

=item *

L<Pithub::Repos::Releases::Assets>

See also: L<http://developer.github.com/v3/repos/releases/>

    my $assets = Pithub->new->repos->releases->assets;
    my $assets = Pithub::Repos->new->releases->assets;
    my $assets = Pithub::Repos::Releases->new->assets;
    my $assets = Pithub::Repos::Releases::Assets->new;

=back

=item *

L<Pithub::Repos::Stats>

See also: L<http://developer.github.com/v3/repos/statistics/>

    my $watching = Pithub->new->repos->stats;
    my $watching = Pithub::Repos->new->stats;
    my $watching = Pithub::Repos::Stats->new;

=item *

L<Pithub::Repos::Statuses>

See also: L<http://developer.github.com/v3/repos/statuses/>

    my $watching = Pithub->new->repos->statuses;
    my $watching = Pithub::Repos->new->statuses;
    my $watching = Pithub::Repos::Statuses->new;

=item *

L<Pithub::Repos::Watching>

See also: L<http://developer.github.com/v3/repos/watching/>

    my $watching = Pithub->new->repos->watching;
    my $watching = Pithub::Repos->new->watching;
    my $watching = Pithub::Repos::Watching->new;

=back

=back

=over

=item *

L<Pithub::Users>

See also: L<http://developer.github.com/v3/users/>

    my $users = Pithub->new->users;
    my $users = Pithub::Users->new;

=over

=item *

L<Pithub::Users::Emails>

See also: L<http://developer.github.com/v3/users/emails/>

    my $emails = Pithub->new->users->emails;
    my $emails = Pithub::Users->new->emails;
    my $emails = Pithub::Users::Emails->new;

=item *

L<Pithub::Users::Followers>

See also: L<http://developer.github.com/v3/users/followers/>

    my $followers = Pithub->new->users->followers;
    my $followers = Pithub::Users->new->followers;
    my $followers = Pithub::Users::Followers->new;

=item *

L<Pithub::Users::Keys>

See also: L<http://developer.github.com/v3/users/keys/>

    my $keys = Pithub->new->users->keys;
    my $keys = Pithub::Users->new->keys;
    my $keys = Pithub::Users::Keys->new;

=back

=back

=back

=cut

=method events

Provides access to L<Pithub::Events>.

=cut

sub events {
    return shift->_create_instance('Pithub::Events');
}

=method gists

Provides access to L<Pithub::Gists>.

=cut

sub gists {
    return shift->_create_instance('Pithub::Gists');
}

=method git_data

Provides access to L<Pithub::GitData>.

=cut

sub git_data {
    return shift->_create_instance('Pithub::GitData');
}

=method issues

Provides access to L<Pithub::Issues>.

=cut

sub issues {
    return shift->_create_instance('Pithub::Issues');
}

=method orgs

Provides access to L<Pithub::Orgs>.

=cut

sub orgs {
    return shift->_create_instance('Pithub::Orgs');
}

=method pull_requests

Provides access to L<Pithub::PullRequests>.

=cut

sub pull_requests {
    return shift->_create_instance('Pithub::PullRequests');
}

=method repos

Provides access to L<Pithub::Repos>.

=cut

sub repos {
    return shift->_create_instance('Pithub::Repos');
}

=method search

Provides access to L<Pithub::Search>.

=cut

sub search {
    return shift->_create_instance('Pithub::Search');
}

=method users

Provides access to L<Pithub::Users>.

=cut

sub users {
    return shift->_create_instance('Pithub::Users');
}

=head1 CONTRIBUTORS

=over

=item *

Andreas Marienborg

=item *

Alessandro Ghedini

=back

=cut

1;
