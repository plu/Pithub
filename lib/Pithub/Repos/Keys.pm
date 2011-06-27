package Pithub::Repos::Keys;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Repos::Keys

=head1 METHODS

=head2 create

=over

=item *

Create

    POST /repos/:user/:repo/keys

=back

Examples:

    $result = $p->repos->keys->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            title => 'some key',
            key   => 'ssh-rsa AAA...',
        },
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/keys', $args{user}, $args{repo} ), $args{data} );
}

=head2 delete

=over

=item *

Delete

    DELETE /repos/:user/:repo/keys/:id

=back

Examples:

    $result = $p->repos->keys->delete(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/keys/%d', $args{user}, $args{repo}, $args{key_id} ) );
}

=head2 get

=over

=item *

Get

    GET /repos/:user/:repo/keys/:id

=back

Examples:

    $result = $p->repos->keys->get(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/keys/%d', $args{user}, $args{repo}, $args{key_id} ) );
}

=head2 list

=over

=item *

List

    GET /repos/:user/:repo/keys

=back

Examples:

    $result = $p->repos->keys->list(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/keys', $args{user}, $args{repo} ) );
}

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo/keys/:id

=back

Examples:

    $result = $p->repos->keys->update(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
        data   => { title => 'some new title' },
    );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/keys/%d', $args{user}, $args{repo}, $args{key_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
