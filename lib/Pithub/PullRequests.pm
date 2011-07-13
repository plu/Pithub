package Pithub::PullRequests;

# ABSTRACT: Github v3 Pull Requests API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
around qr{^merge_.*?_args$} => \&Pithub::Base::_merge_args;

=method commits

=over

=item *

List commits on a pull request

    GET /repos/:user/:repo/pulls/:id/commits

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->commits(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1
    );

=back

=cut

sub commits {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%s/commits', $args{user}, $args{repo}, $args{pull_request_id} ) );
}

=method create

=over

=item *

Create a pull request

    POST /repos/:user/:repo/pulls

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->create(
        user   => 'plu',
        repo => 'Pithub',
        data   => {
            base  => 'master',
            body  => 'Please pull this in!',
            head  => 'octocat:new-feature',
            title => 'Amazing new feature',
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/pulls', $args{user}, $args{repo} ), $args{data} );
}

=method files

=over

=item *

List pull requests files

    GET /repos/:user/:repo/pulls/:id/files

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->files(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=back

=cut

sub files {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%s/files', $args{user}, $args{repo}, $args{pull_request_id} ) );
}

=method get

=over

=item *

Get a single pull request

    GET /repos/:user/:repo/pulls/:id

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->get(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%s', $args{user}, $args{repo}, $args{pull_request_id} ) );
}

=method is_merged

=over

=item *

Get if a pull request has been merged

    GET /repos/:user/:repo/pulls/:id/merge

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->is_merged(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=back

=cut

sub is_merged {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%s/merge', $args{user}, $args{repo}, $args{pull_request_id} ) );
}

=method list

=over

=item *

List pull requests

    GET /repos/:user/:repo/pulls

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->list(
        user => 'plu',
        repo => 'Pithub'
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls', $args{user}, $args{repo} ) );
}

=method merge

=over

=item *

Merge a pull request

    PUT /repos/:user/:repo/pulls/:id/merge

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->merge(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=back

=cut

sub merge {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/repos/%s/%s/pulls/%s/merge', $args{user}, $args{repo}, $args{pull_request_id} ) );
}

=method update

=over

=item *

Update a pull request

    PATCH /repos/:user/:repo/pulls/:id

Examples:

    my $p = Pithub::PullRequests->new;
    my $result = $p->update(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
        data            => {
            base  => 'master',
            body  => 'Please pull this in!',
            head  => 'octocat:new-feature',
            title => 'Amazing new feature',
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/pulls/%s', $args{user}, $args{repo}, $args{pull_request_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
