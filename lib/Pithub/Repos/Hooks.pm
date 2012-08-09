package Pithub::Repos::Hooks;

# ABSTRACT: Github v3 Repo Hooks API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=head1 EVENTS

Active hooks can be configured to trigger for one or more events.
The default event is push. The available events are:

=over

=item *

commit_comment - Any time a Commit is commented on.

=item *

download - Any time a Download is added to the Repository.

=item *

fork - Any time a Repository is forked.

=item *

fork_apply - Any time a patch is applied to the Repository from
the Fork Queue.

=item *

gollum - Any time a Wiki page is updated.

=item *

issues - Any time an Issue is opened or closed.

=item *

issue_comment - Any time an Issue is commented on.

=item *

member - Any time a User is added as a collaborator to a
non-Organization Repository.

=item *

public - Any time a Repository changes from private to public.

=item *

pull_request - Any time a Pull Request is opend, closed, or
synchronized (updated due to a new push in the branch that
the pull request is tracking).

=item *

push - Any git push to a Repository.

=item *

watch - Any time a User watches the Repository.

=back

=method create

=over

=item *

Create a hook

    POST /repos/:user/:repo/hooks

Examples:

    my $hooks  = Pithub::Repos::Hooks->new;
    my $result = $hooks->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            name   => 'irc',
            active => 1,
            config => {
                server => 'irc.perl.org',
                port   => 6667,
                room   => 'pithub',
            },
        },
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/hooks', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method delete

=over

=item *

Delete a hook

    DELETE /repos/:user/:repo/hooks/:id

Examples:

    my $hooks  = Pithub::Repos::Hooks->new;
    my $result = $hooks->delete(
        user    => 'plu',
        repo    => 'Pithub',
        hook_id => 5,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: hook_id' unless $args{hook_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/hooks/%d', delete $args{user}, delete $args{repo}, delete $args{hook_id} ),
        %args,
    );
}

=method get

=over

=item *

Get single hook

    GET /repos/:user/:repo/hooks/:id

Examples:

    my $hooks  = Pithub::Repos::Hooks->new;
    my $result = $hooks->get(
        user    => 'plu',
        repo    => 'Pithub',
        hook_id => 5,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: hook_id' unless $args{hook_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/hooks/%d', delete $args{user}, delete $args{repo}, delete $args{hook_id} ),
        %args,
    );
}

=method list

=over

=item *

List Hooks

    GET /repos/:user/:repo/hooks

Examples:

    my $hooks  = Pithub::Repos::Hooks->new;
    my $result = $hooks->tags( user => 'plu', repo => 'Pithub' );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/hooks', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method test

=over

=item *

Get single hook

    POST /repos/:user/:repo/hooks/:id/test

Examples:

    my $hooks  = Pithub::Repos::Hooks->new;
    my $result = $hooks->test(
        user    => 'plu',
        repo    => 'Pithub',
        hook_id => 5,
    );

=back

=cut

sub test {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: hook_id' unless $args{hook_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/hooks/%d/test', delete $args{user}, delete $args{repo}, delete $args{hook_id} ),
        %args,
    );
}

=method update

=over

=item *

Update/edit a hook

    PATCH /repos/:user/:repo/hooks/:id

Examples:

    my $hooks  = Pithub::Repos::Hooks->new;
    my $result = $hooks->update(
        user    => 'plu',
        repo    => 'Pithub',
        hook_id => 5,
        data    => {
            name   => 'irc',
            active => 1,
            config => {
                server => 'irc.freenode.net',
                port   => 6667,
                room   => 'pithub',
            },
        },
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: hook_id' unless $args{hook_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/hooks/%d', delete $args{user}, delete $args{repo}, delete $args{hook_id} ),
        %args,
    );
}

1;
