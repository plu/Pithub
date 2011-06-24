package Pithub::Users;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Emails' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Followers' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub::Users

=head1 METHODS

=head2 get

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
    $result = $p->users->get('plu');

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->get;

    $u = Pithub::Users->new;
    $result = $u->get('plu');

    $u = Pithub::Users->new( token => 'b3c62c6' );
    $result = $u->get;

=cut

sub get {
    my ( $self, $user ) = @_;
    if ($user) {
        return $self->request( GET => sprintf( '/users/%s', $user ) );
    }
    return $self->request( GET => '/user' );
}

=head2 update

=over

=item *

Update the authenticated user

    PATCH /user

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->update( { email => 'plu@cpan.org' } );

    $u = Pithub::Users->new( token => 'b3c62c6' );
    $result = $u->update( { email => 'plu@cpan.org' } );

=cut

sub update {
    my ( $self, $args ) = @_;
    croak 'Missing parameter: $data (hashref)' unless ref $args eq 'HASH';
    return $self->request( PATCH => '/user', $args );
}

__PACKAGE__->meta->make_immutable;

1;
