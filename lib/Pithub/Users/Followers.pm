package Pithub::Users::Followers;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Users::Followers

=head1 METHODS

=head2 follow

=over

=item *

Follow a user

    PUT /user/following/:user

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->followers->follow('plu');

    $f = Pithub::Users::Followers->new( token => 'b3c62c6' );
    $result = $f->follow('plu');

=cut

sub follow {
    my ( $self, $user ) = @_;
    croak 'Missing parameter: $user' unless $user;
    return $self->request( PUT => sprintf( '/user/following/%s', $user ) );
}

=head2 is_following

=over

=item *

Check if the authenticated user is following another given user

    GET /user/following/:user

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->followers->is_following('rafl');

    $f = Pithub::Users::Followers->new( token => 'b3c62c6' );
    $result = $f->is_following('rafl');

    if ( $result->is_success ) {
        print "plu is following rafl\n";
    }
    elsif ( $result->code == 404 ) {
        print "plu is not following rafl\n";
    }

=cut

sub is_following {
    my ( $self, $user ) = @_;
    croak 'Missing parameter: $user' unless $user;
    return $self->request( GET => sprintf( '/user/following/%s', $user ) );
}

=head2 list

=over

=item *

List a user's followers:

    GET /users/:user/followers

=item *

List the authenticated user's followers:

    GET /user/followers

=back

Examples:

    $p = Pithub->new;
    $result = $p->users->followers->list('plu');

    $f = Pithub::Users::Followers->new;
    $result = $f->list('plu');

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->followers->list;

    $f = Pithub::Users::Followers->new( token => 'b3c62c6' );
    $result = $f->list;

=cut

sub list {
    my ( $self, $user ) = @_;
    if ($user) {
        return $self->request( GET => sprintf( '/users/%s/followers', $user ) );
    }
    return $self->request( GET => '/user/followers' );
}

=head2 list_following

=over

=item *

List who a user is following:

    GET /users/:user/following

=item *

List who the authenicated user is following:

    GET /user/following

=back

Examples:

    $p = Pithub->new;
    $result = $p->users->followers->list_following('plu');

    $f = Pithub::Users::Followers->new;
    $result = $f->list_following('plu');

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->followers->list_following;

    $f = Pithub::Users::Followers->new( token => 'b3c62c6' );
    $result = $f->list_following;

=cut

sub list_following {
    my ( $self, $user ) = @_;
    if ($user) {
        return $self->request( GET => sprintf( '/user/%s/following', $user ) );
    }
    return $self->request( GET => '/user/following' );
}

=head2 unfollow

=over

=item *

Unfollow a user

    DELETE /user/following/:user

=back

Examples:

    $p = Pithub->new;
    $result = $p->users->followers->unfollow('plu');

    $f = Pithub::Users::Followers->new;
    $result = $f->unfollow('plu');

=cut

sub unfollow {
    my ( $self, $user ) = @_;
    croak 'Missing parameter: $user' unless $user;
    return $self->request( DELETE => sprintf( '/user/following/%s', $user ) );
}

__PACKAGE__->meta->make_immutable;

1;
