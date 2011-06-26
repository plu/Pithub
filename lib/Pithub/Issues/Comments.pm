package Pithub::Issues::Comments;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Issues::Comments

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /repos/:user/:repo/issues/:id/comments

=back

Examples:

    my $result = $p->issues->comments->create( repo => 'Pithub', user => 'plu', issue_id => 1, data => { body => 'some comment' } );

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/issues/comments/:id

=back

Examples:

    $result = $p->issues->comments->delete(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/comments/%d', $args{user}, $args{repo}, $args{comment_id} ) );
}

=head2 get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/issues/comments/:id

=back

Examples:

    $result = $p->issues->comments->get(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/comments/%d', $args{user}, $args{repo}, $args{comment_id} ) );
}

=head2 list

=over

=item *

List comments on an issue

    GET /repos/:user/:repo/issues/:id/comments

=back

Examples:

    $result = $p->issues->comments->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/%d/comments', $args{user}, $args{repo}, $args{issue_id} ) );
}

=head2 update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/issues/comments/:id

=back

Examples:

    my $result = $p->issues->comments->update( repo => 'Pithub', user => 'plu', comment_id => 1, data => { body => 'some comment' } );

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
