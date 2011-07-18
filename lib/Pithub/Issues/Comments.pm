package Pithub::Issues::Comments;

# ABSTRACT: Github v3 Issue Comments API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Create a comment

    POST /repos/:user/:repo/issues/:id/comments

Examples:

    my $c = Pithub::Issues::Comments->new;
    my $result = $c->create(
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
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/issues/%s/comments', delete $args{user}, delete $args{repo}, delete $args{issue_id} ),
        %args,
    );
}

=method delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/issues/comments/:id

Examples:

    my $c = Pithub::Issues::Comments->new;
    my $result = $c->delete(
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
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/issues/comments/%s', delete $args{user}, delete $args{repo}, delete $args{comment_id} ),
        %args,
    );
}

=method get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/issues/comments/:id

Examples:

    my $c = Pithub::Issues::Comments->new;
    my $result = $c->get(
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
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/issues/comments/%s', delete $args{user}, delete $args{repo}, delete $args{comment_id} ),
        %args,
    );
}

=method list

=over

=item *

List comments on an issue

    GET /repos/:user/:repo/issues/:id/comments

Examples:

    my $c = Pithub::Issues::Comments->new;
    my $result = $c->list(
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
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/issues/%s/comments', delete $args{user}, delete $args{repo}, delete $args{issue_id} ),
        %args,
    );
}

=method update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/issues/comments/:id

Examples:

    my $c = Pithub::Issues::Comments->new;
    my $result = $c->update(
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
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/issues/comments/%s', delete $args{user}, delete $args{repo}, delete $args{comment_id} ),
        %args,
    );
}

1;
