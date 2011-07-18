package Pithub::Users::Keys;

# ABSTRACT: Github v3 User Keys API

use Moo;
use Carp qw(croak);
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
    return $self->request(
        method => 'POST',
        path   => '/user/keys',
        %args,
    );
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
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/user/keys/%s', delete $args{key_id} ),
        %args,
    );
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
    return $self->request(
        method => 'GET',
        path   => sprintf( '/user/keys/%s', delete $args{key_id} ),
        %args,
    );
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
    my ( $self, %args ) = @_;
    return $self->request(
        method => 'GET',
        path   => '/user/keys',
        %args,
    );
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
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/user/keys/%s', delete $args{key_id} ),
        %args,
    );
}

1;
