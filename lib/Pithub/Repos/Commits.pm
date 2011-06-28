package Pithub::Repos::Commits;

# ABSTRACT: Github v3 Repo Commits API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create_comment

=over

=item *

Create a commit comment

    POST /repos/:user/:repo/commits/:sha/comments

=back

Examples:

    $result = $p->repos->commits->create_comment(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
        data => { body => 'some comment' },
    );

=cut

sub create_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/commits/%s/comments', $args{user}, $args{repo}, $args{sha} ), $args{data} );
}

=method delete_comment

=over

=item *

Delete a commit comment

    DELETE /repos/:user/:repo/comments/:id

=back

Examples:

    $result = $p->repos->commits->delete_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=cut

sub delete_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/comments/%d', $args{user}, $args{repo}, $args{comment_id} ) );
}

=method get

=over

=item *

Get a single commit

    GET /repos/:user/:repo/commits/:sha

=back

Examples:

    $result = $p->repos->commits->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/commits/%s', $args{user}, $args{repo}, $args{sha} ) );
}

=method get_comment

=over

=item *

Get a single commit comment

    GET /repos/:user/:repo/comments/:id

=back

Examples:

    $result = $p->repos->commits->get_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=cut

sub get_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}

=method list

=over

=item *

List commits on a repository

    GET /repos/:user/:repo/commits

=back

Examples:

    $result = $p->repos->commits->list(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/commits', $args{user}, $args{repo} ) );
}

=method list_comments

=over

=item *

List commit comments for a repository

Commit Comments leverage these custom mime types. You can read more
about the use of mimes types in the API here. TODO: Link github API

    GET /repos/:user/:repo/comments

Examples:

    $result = $p->repos->commits->list_comments(
        user => 'plu',
        repo => 'Pithub',
    );

=item *

List comments for a single commit

    GET /repos/:user/:repo/commits/:sha/comments

=back

Examples:

    $result = $p->repos->commits->list_comments(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=cut

sub list_comments {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $sha = $args{sha} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/commits/%s/comments', $args{user}, $args{repo}, $sha ) );
    }
    return $self->request( GET => sprintf( '/repos/%s/%s/comments', $args{user}, $args{repo} ) );
}

=method update_comment

=over

=item *

Update a commit comment

    PATCH /repos/:user/:repo/comments/:id

=back

Examples:

    $result = $p->repos->commits->update_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
        data       => { body => 'updated comment' },
    );

=cut

sub update_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/comments/%s', $args{user}, $args{repo}, $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
