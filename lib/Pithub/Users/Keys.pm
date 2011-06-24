package Pithub::Users::Keys;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Users::Keys

=head1 METHODS

=head2 create

=over

=item *

Create a public key

    POST /user/keys

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->create(
        {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->create(
        {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=cut

sub create {
    my ( $self, $data ) = @_;
    croak 'Missing parameter: $data (hashref)' unless ref $data eq 'HASH';
    return $self->request( POST => '/user/keys', $data );
}

=head2 delete

=over

=item *

Delete a public key

    DELETE /user/keys/:id

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->delete(123);

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->delete(123);

=cut

sub delete {
    my ( $self, $key_id ) = @_;
    croak 'Missing parameter: $key_id' unless $key_id;
    return $self->request( DELETE => sprintf( '/user/keys/%d', $key_id ) );
}

=head2 get

=over

=item *

Get a single public key

    GET /user/keys/:id

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->get(123);

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->get(123);

=cut

sub get {
    my ( $self, $key_id ) = @_;
    croak 'Missing parameter: $key_id' unless $key_id;
    return $self->request( GET => sprintf( '/user/keys/%d', $key_id ) );
}

=head2 list

=over

=item *

List public keys for a user

    GET /user/keys

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->list;

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->list;

=cut

sub list {
    my ($self) = @_;
    return $self->request( GET => '/user/keys' );
}

=head2 update

=over

=item *

Update a public key

    PATCH /user/keys/:id

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->update(
        123 => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->update(
        123 => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=cut

sub update {
    my ( $self, $key_id, $data ) = @_;
    croak 'Missing parameter: $key_id' unless $key_id;
    croak 'Missing parameter: $data (hashref)' unless ref $data eq 'HASH';
    return $self->request( PATCH => sprintf( '/user/keys/%d', $key_id ), $data );
}

__PACKAGE__->meta->make_immutable;

1;
