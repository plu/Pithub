package Pithub::Users;

# ABSTRACT: Github v3 Users API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Emails' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Followers' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=method get

=over

=item *

Get a single user

    GET /users/:user

=item *

Get the authenticated user

    GET /user

=back

Examples:

    $p = Pithub->new;
    $result = $p->users->get( user => 'plu');

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->get;

    $u = Pithub::Users->new;
    $result = $u->get( user => 'plu');

    $u = Pithub::Users->new( token => 'b3c62c6' );
    $result = $u->get;

=cut

sub get {
    my ( $self, %args ) = @_;
    if ( $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s', $args{user} ) );
    }
    return $self->request( GET => '/user' );
}

=method update

=over

=item *

Update the authenticated user

    PATCH /user

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->update( data => { email => 'plu@cpan.org' } );

    $u = Pithub::Users->new( token => 'b3c62c6' );
    $result = $u->update( data => { email => 'plu@cpan.org' } );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => '/user', $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
