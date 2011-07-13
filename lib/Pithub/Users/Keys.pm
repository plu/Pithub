package Pithub::Users::Keys;

# ABSTRACT: Github v3 User Keys API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a public key

    POST /user/keys

Examples:

    my $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    my $result = $k->create(
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => '/user/keys', $args{data} );
}

=method delete

=over

=item *

Delete a public key

    DELETE /user/keys/:id

Examples:

    my $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    my $result = $k->delete( key_id => 123 );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    return $self->request( DELETE => sprintf( '/user/keys/%s', $args{key_id} ) );
}

=method get

=over

=item *

Get a single public key

    GET /user/keys/:id

Examples:

    my $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    my $result = $k->get( key_id => 123 );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    return $self->request( GET => sprintf( '/user/keys/%s', $args{key_id} ) );
}

=method list

=over

=item *

List public keys for a user

    GET /user/keys

Examples:

    my $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    my $result = $k->list;

=back

=cut

sub list {
    my ($self) = @_;
    return $self->request( GET => '/user/keys' );
}

=method update

=over

=item *

Update a public key

    PATCH /user/keys/:id

Examples:

    my $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    my $result = $k->update(
        key_id => 123,
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/user/keys/%s', $args{key_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
