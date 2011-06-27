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
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->create(
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => '/user/keys', $args{data} );
}

=head2 delete

=over

=item *

Delete a public key

    DELETE /user/keys/:id

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->delete( key_id => 123 );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->delete( key_id => 123 );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    return $self->request( DELETE => sprintf( '/user/keys/%d', $args{key_id} ) );
}

=head2 get

=over

=item *

Get a single public key

    GET /user/keys/:id

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->get( key_id => 123 );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->get( key_id => 123 );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    return $self->request( GET => sprintf( '/user/keys/%d', $args{key_id} ) );
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
        key_id => 123,
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->update(
        key_id => 123,
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/user/keys/%d', $args{key_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
