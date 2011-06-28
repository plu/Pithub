package Pithub::Orgs::Members;

# ABSTRACT: Github v3 Org Members API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method conceal

=over

=item *

Conceal a user's membership

    DELETE /orgs/:org/public_members/:user

=back

Examples:

    $result = $p->orgs->members->conceal(
        org  => 'CPAN-API',
        user => 'plu',
    );

=cut

sub conceal {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request( DELETE => sprintf( '/orgs/%s/public_members/%s', $args{org}, $args{user} ) );
}

=method delete

=over

=item *

Removing a user from this list will remove them from all teams and
they will no longer have any access to the organization’s
repositories.

    DELETE /orgs/:org/members/:user

=back

Examples:

    $result = $p->orgs->members->delete(
        org  => 'CPAN-API',
        user => 'plu',
    );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request( DELETE => sprintf( '/orgs/%s/members/%s', $args{org}, $args{user} ) );
}

=method is_member

=over

=item *

Check if a user is a member of an organization

    GET /orgs/:org/members/:user

=back

Examples:

    $result = $p->orgs->members->is_member(
        org  => 'CPAN-API',
        user => 'plu',
    );

=cut

sub is_member {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request( GET => sprintf( '/orgs/%s/members/%s', $args{org}, $args{user} ) );
}

=method is_public

=over

=item *

Get if a user is a public member

    GET /orgs/:org/public_members/:user

=back

Examples:

    $result = $p->orgs->members->is_public(
        org  => 'CPAN-API',
        user => 'plu',
    );

=cut

sub is_public {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request( GET => sprintf( '/orgs/%s/public_members/%s', $args{org}, $args{user} ) );
}

=method list

=over

=item *

List all users who are members of an organization. A member is a user
that belongs to at least 1 team in the organization. If the
authenticated user is also a member of this organization then both
concealed and public members will be returned. Otherwise only public
members are returned.

    GET /orgs/:org/members

=back

Examples:

    $result = $p->orgs->members->list( org => 'CPAN-API' );

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request( GET => sprintf( '/orgs/%s/members', $args{org} ) );
}

=method list_public

=over

=item *

Members of an organization can choose to have their membership
publicized or not.

    GET /orgs/:org/public_members

=back

Examples:

    $result = $p->orgs->members->list_public( org => 'CPAN-API' );

=cut

sub list_public {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request( GET => sprintf( '/orgs/%s/public_members', $args{org} ) );
}

=method publicize

=over

=item *

Publicize a user's membership

    PUT /orgs/:org/public_members/:user

=back

Examples:

    $result = $p->orgs->members->publicize(
        org  => 'CPAN-API',
        user => 'plu',
    );

=cut

sub publicize {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request( PUT => sprintf( '/orgs/%s/public_members/%s', $args{org}, $args{user} ) );
}

__PACKAGE__->meta->make_immutable;

1;
