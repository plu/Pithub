package Pithub;

# ABSTRACT: Github v3 API

use Moose;
use Class::MOP;
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Gists' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::GitData' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Issues' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Orgs' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::PullRequests' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Repos' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Users' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub - Github v3 API

=head1 SYNOPSIS

    use Pithub;
    use Data::Dumper;

    $result = Pithub->new->repos->get( user => 'plu', repo => 'Pithub' );
    print Dumper $result->content;

    $result = Pithub->new( user => 'plu' )->repos->get( repo => 'Pithub' );
    print Dumper $result->content;

    $result = Pithub->new( user => 'plu', repo => 'Pithub' )->repos->get;
    print Dumper $result->content;

    $result = Pithub::Repos->new->get( user => 'plu', repo => 'Pithub' );
    print Dumper $result->content;

    $result = Pithub::Repos->new( user => 'plu' )->get( repo => 'Pithub' );
    print Dumper $result->content;

    $result = Pithub::Repos->new( user => 'plu', repo => 'Pithub' )->get;
    print Dumper $result->content;

=head1 WARNING

L<Pithub> as well as the
L<Github v3 API|http://developer.github.com/v3/> are still under
development. So there might be things broken on both sides. Besides
that it's possible that the API will change. This applies to
L<Pithub> itself as well as the
L<Github v3 API|http://developer.github.com/v3/>.

=head1 MODULES

There are different ways of using Pithub library. You can either
use the main module C<< Pithub >> to get access to all other
modules like L<Pithub::Repos> for example, or you can use
L<Pithub::Repos> directly. In the synopsis above, all the calls
are equivalent. Here's an overview over all modules and how to
get access to them:

=over

=item *

L<Pithub::Gists>

See also: L<http://developer.github.com/v3/gists/>

    $gists = Pithub->new->gists;
    $gists = Pithub::Gists->new;

=over

=item *

L<Pithub::Gists::Comments>

See also: L<http://developer.github.com/v3/gists/comments/>

    $comments = Pithub->new->gists->comments;
    $comments = Pithub::Gists->new->comments;
    $comments = Pithub::Gists::Comments->new;

=back

=back

=over

=item *

L<Pithub::GitData>

See also: L<http://developer.github.com/v3/git/>

    $git_data = Pithub->new->git_data;
    $git_data = Pithub::GitData->new;

=over

=item *

L<Pithub::GitData::Blobs>

See also: L<http://developer.github.com/v3/git/blobs/>

    $blobs = Pithub->new->git_data->blobs;
    $blobs = Pithub::GitData->new->blobs;
    $blobs = Pithub::GitData::Blobs->new;

=item *

L<Pithub::GitData::Commits>

See also: L<http://developer.github.com/v3/git/commits/>

    $commits = Pithub->new->git_data->commits;
    $commits = Pithub::GitData->new->commits;
    $commits = Pithub::GitData::Commits->new;

=item *

L<Pithub::GitData::References>

See also: L<http://developer.github.com/v3/git/refs/>

    $references = Pithub->new->git_data->references;
    $references = Pithub::GitData->new->references;
    $references = Pithub::GitData::References->new;

=item *

L<Pithub::GitData::Tags>

See also: L<http://developer.github.com/v3/git/tags/>

    $tags = Pithub->new->git_data->tags;
    $tags = Pithub::GitData->new->tags;
    $tags = Pithub::GitData::Tags->new;

=item *

L<Pithub::GitData::Trees>

See also: L<http://developer.github.com/v3/git/trees/>

    $trees = Pithub->new->git_data->trees;
    $trees = Pithub::GitData->new->trees;
    $trees = Pithub::GitData::Trees->new;

=back

=back

=over

=item *

L<Pithub::Issues>

See also: L<http://developer.github.com/v3/issues/>

    $issues = Pithub->new->issues;
    $issues = Pithub::Issues->new;

=over

=item *

L<Pithub::Issues::Comments>

See also: L<http://developer.github.com/v3/issues/comments/>

    $comments = Pithub->new->issues->comments;
    $comments = Pithub::Issues->new->comments;
    $comments = Pithub::Issues::Comments->new;

=item *

L<Pithub::Issues::Events>

See also: L<http://developer.github.com/v3/issues/events/>

    $events = Pithub->new->issues->events;
    $events = Pithub::Issues->new->events;
    $events = Pithub::Issues::Events->new;

=item *

L<Pithub::Issues::Labels>

See also: L<http://developer.github.com/v3/issues/labels/>

    $labels = Pithub->new->issues->labels;
    $labels = Pithub::Issues->new->labels;
    $labels = Pithub::Issues::Labels->new;

=item *

L<Pithub::Issues::Milestones>

See also: L<http://developer.github.com/v3/issues/milestones/>

    $milestones = Pithub->new->issues->milestones;
    $milestones = Pithub::Issues->new->milestones;
    $milestones = Pithub::Issues::Milestones->new;

=back

=back

=over

=item *

L<Pithub::Orgs>

See also: L<http://developer.github.com/v3/orgs/>

    $orgs = Pithub->new->orgs;
    $orgs = Pithub::Orgs->new;

=over

=item *

L<Pithub::Orgs::Members>

See also: L<http://developer.github.com/v3/orgs/members/>

    $members = Pithub->new->orgs->members;
    $members = Pithub::Orgs->new->members;
    $members = Pithub::Orgs::Members->new;

=item *

L<Pithub::Orgs::Teams>

See also: L<http://developer.github.com/v3/orgs/teams/>

    $teams = Pithub->new->orgs->teams;
    $teams = Pithub::Orgs->new->teams;
    $teams = Pithub::Orgs::Teams->new;

=back

=back

=over

=item *

L<Pithub::PullRequests>

See also: L<http://developer.github.com/v3/pulls/>

    $pull_requests = Pithub->new->pull_requests;
    $pull_requests = Pithub::PullRequests->new;

=over

=item *

L<Pithub::PullRequests::Comments>

See also: L<http://developer.github.com/v3/pulls/comments/>

    $comments = Pithub->new->pull_requests->comments;
    $comments = Pithub::PullRequests->new->comments;
    $comments = Pithub::PullRequests::Comments->new;

=back

=back

=over

=item *

L<Pithub::Repos>

See also: L<http://developer.github.com/v3/repos/>

    $repos = Pithub->new->repos;
    $repos = Pithub::Repos->new;

=over

=item *

L<Pithub::Repos::Collaborators>

See also: L<http://developer.github.com/v3/repos/collaborators/>

    $collaborators = Pithub->new->repos->collaborators;
    $collaborators = Pithub::Repos->new->collaborators;
    $collaborators = Pithub::Repos::Collaborators->new;

=item *

L<Pithub::Repos::Commits>

See also: L<http://developer.github.com/v3/repos/commits/>

    $commits = Pithub->new->repos->commits;
    $commits = Pithub::Repos->new->commits;
    $commits = Pithub::Repos::Commits->new;

=item *

L<Pithub::Repos::Downloads>

See also: L<http://developer.github.com/v3/repos/downloads/>

    $downloads = Pithub->new->repos->downloads;
    $downloads = Pithub::Repos->new->downloads;
    $downloads = Pithub::Repos::Downloads->new;

=item *

L<Pithub::Repos::Forks>

See also: L<http://developer.github.com/v3/repos/forks/>

    $forks = Pithub->new->repos->forks;
    $forks = Pithub::Repos->new->forks;
    $forks = Pithub::Repos::Forks->new;

=item *

L<Pithub::Repos::Keys>

See also: L<http://developer.github.com/v3/repos/keys/>

    $keys = Pithub->new->repos->keys;
    $keys = Pithub::Repos->new->keys;
    $keys = Pithub::Repos::Keys->new;

=item *

L<Pithub::Repos::Watching>

See also: L<http://developer.github.com/v3/repos/watching/>

    $watching = Pithub->new->repos->watching;
    $watching = Pithub::Repos->new->watching;
    $watching = Pithub::Repos::Watching->new;

=back

=back

=over

=item *

L<Pithub::Users>

See also: L<http://developer.github.com/v3/users/>

    $users = Pithub->new->users;
    $users = Pithub::Users->new;

=over

=item *

L<Pithub::Users::Emails>

See also: L<http://developer.github.com/v3/users/emails/>

    $emails = Pithub->new->users->emails;
    $emails = Pithub::Users->new->emails;
    $emails = Pithub::Users::Emails->new;

=item *

L<Pithub::Users::Followers>

See also: L<http://developer.github.com/v3/users/followers/>

    $followers = Pithub->new->users->followers;
    $followers = Pithub::Users->new->followers;
    $followers = Pithub::Users::Followers->new;

=item *

L<Pithub::Users::Keys>

See also: L<http://developer.github.com/v3/users/keys/>

    $keys = Pithub->new->users->keys;
    $keys = Pithub::Users->new->keys;
    $keys = Pithub::Users::Keys->new;

=back

=back

Besides that there are other modules involved. Every method call
which maps directly to a Github API call returns a
L<Pithub::Result> object. This contains everything interesting
about the response (L<Pithub::Response>) returned from the API
call as well as the request (L<Pithub::Request>). Even the
L<Pithub::Base> module might be interesting because this one
provides the L<Pithub::Base/request> method, which is used by
all other modules. In case Github adds a new API call which is
not supported yet by L<Pithub> the L<Pithub::Base/request>
method can be used directly.

=cut

__PACKAGE__->meta->make_immutable;

1;
