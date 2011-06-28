package Pithub::Issues::Milestones;

# ABSTRACT: Github v3 Issue Milestones API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a milestone

    POST /repos/:user/:repo/milestones

Examples:

    $result = $p->issues->milestones->create(
        repo => 'Pithub',
        user => 'plu',
        data => {
            description => 'String',
            due_on      => 'Time',
            state       => 'open or closed',
            title       => 'String'
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/milestones', $args{user}, $args{repo} ), $args{data} );
}

=method delete

=over

=item *

Delete a milestone

    DELETE /repos/:user/:repo/milestones/:id

Examples:

    $result = $p->issues->milestones->delete(
        repo => 'Pithub',
        user => 'plu',
        milestone_id => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/milestones/%d', $args{user}, $args{repo}, $args{milestone_id} ) );
}

=method get

=over

=item *

Get a single milestone

    GET /repos/:user/:repo/milestones/:id

Examples:

    $result = $p->issues->milestones->get(
        repo => 'Pithub',
        user => 'plu',
        milestone_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/milestones/%d', $args{user}, $args{repo}, $args{milestone_id} ) );
}

=method list

=over

=item *

List milestones for an issue

    GET /repos/:user/:repo/milestones

Examples:

    $result = $p->issues->milestones->list(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/milestones', $args{user}, $args{repo} ) );
}

=method update

=over

=item *

Update a milestone

    PATCH /repos/:user/:repo/milestones/:id

Examples:

    $result = $p->issues->milestones->update(
        repo => 'Pithub',
        user => 'plu',
        data => {
            description => 'String',
            due_on      => 'Time',
            state       => 'open or closed',
            title       => 'String'
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/milestones/%d', $args{user}, $args{repo}, $args{milestone_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
