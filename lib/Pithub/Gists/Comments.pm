package Pithub::Gists::Comments;

# ABSTRACT: Github v3 Gist Comments API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a comment

    POST /gists/:gist_id/comments

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->create(
        gist_id => 1,
        data    => { body => 'some comment' },
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => sprintf( '/gists/%s/comments', $args{gist_id} ), $args{data} );
}

=method delete

=over

=item *

Delete a comment

    DELETE /gists/comments/:id

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->delete( comment_id => 1 );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    return $self->request( DELETE => sprintf( '/gists/comments/%s', $args{comment_id} ) );
}

=method get

=over

=item *

Get a single comment

    GET /gists/comments/:id

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->get( comment_id => 1 );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    return $self->request( GET => sprintf( '/gists/comments/%s', $args{comment_id} ) );
}

=method list

=over

=item *

List comments on a gist

    GET /gists/:gist_id/comments

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->list( gist_id => 1 );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( GET => sprintf( '/gists/%s/comments', $args{gist_id} ) );
}

=method update

=over

=item *

Edit a comment

    PATCH /gists/comments/:id

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->update(
        comment_id => 1,
        data       => { body => 'some comment' }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/gists/comments/%s', $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
