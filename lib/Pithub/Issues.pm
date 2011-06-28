package Pithub::Issues;

# ABSTRACT: Github v3 Issues API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Events' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Labels' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Milestones' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=method create

=over

=item *

Create an issue

    POST /repos/:user/:repo/issues

Examples:

    $result = $p->issues->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            assignee  => 'octocat',
            body      => "I'm having a problem with this.",
            labels    => [ 'Label1', 'Label2' ],
            milestone => 1,
            title     => 'Found a bug'
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues', $args{user}, $args{repo} ), $args{data} );
}

=method get

=over

=item *

Get a single issue

    GET /repos/:user/:repo/issues/:id

Examples:

    $result = $p->issues->get(
        user => 'plu',
        repo => 'Pithub',
        issue_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/%s', $args{user}, $args{repo}, $args{issue_id} ) );
}

=method list

=over

=item *

List issues for a repository

    GET /repos/:user/:repo/issues

Examples:

    $result = $p->issues->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues', $args{user}, $args{repo} ) );
}

=method update

=over

=item *

Edit an issue

    PATCH /repos/:user/:repo/issues/:id

Examples:

    $result = $p->issues->update(
        user     => 'plu',
        repo     => 'Pithub',
        issue_id => 1,
        data     => {
            assignee  => 'octocat',
            body      => "I'm having a problem with this.",
            labels    => [ 'Label1', 'Label2' ],
            milestone => 1,
            state     => 'open',
            title     => 'Found a bug'
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/issues/%s', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
