package Pithub::Issues::Comments;

# ABSTRACT: Github v3 Issue Comments API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a comment

    POST /repos/:user/:repo/issues/:id/comments

Examples:

    $result = $p->issues->comments->create(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => { body => 'some comment' }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues/%d/comments', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}

=method delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/issues/comments/:id

Examples:

    $result = $p->issues->comments->delete(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/comments/%d', $args{user}, $args{repo}, $args{comment_id} ) );
}

=method get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/issues/comments/:id

Examples:

    $result = $p->issues->comments->get(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/comments/%d', $args{user}, $args{repo}, $args{comment_id} ) );
}

=method list

=over

=item *

List comments on an issue

    GET /repos/:user/:repo/issues/:id/comments

Examples:

    $result = $p->issues->comments->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/%d/comments', $args{user}, $args{repo}, $args{issue_id} ) );
}

=method update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/issues/comments/:id

Examples:

    $result = $p->issues->comments->update(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
        data       => { body => 'some comment' },
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/issues/comments/%d', $args{user}, $args{repo}, $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
