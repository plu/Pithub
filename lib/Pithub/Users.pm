package Pithub::Users;

# ABSTRACT: Github v3 Users API

use Moo;
use Carp qw(croak);
use Pithub::Users::Emails;
use Pithub::Users::Followers;
use Pithub::Users::Keys;
extends 'Pithub::Base';

sub emails {
    return shift->_create_instance('Pithub::Users::Emails');
}

sub followers {
    return shift->_create_instance('Pithub::Users::Followers');
}

sub keys {
    return shift->_create_instance('Pithub::Users::Keys');
}

=method get

=over

=item *

Get a single user

    GET /users/:user

Examples:

    my $u = Pithub::Users->new;
    my $result = $u->get( user => 'plu');

=item *

Get the authenticated user

    GET /user

Examples:

    my $u = Pithub::Users->new( token => 'b3c62c6' );
    my $result = $u->get;

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    if ( $args{user} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/users/%s', delete $args{user} ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => '/user',
        %args,
    );
}

=method update

=over

=item *

Update the authenticated user

    PATCH /user

Examples:

    my $u = Pithub::Users->new( token => 'b3c62c6' );
    my $result = $u->update( data => { email => 'plu@cpan.org' } );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'PATCH',
        path   => '/user',
        %args,
    );
}

1;
