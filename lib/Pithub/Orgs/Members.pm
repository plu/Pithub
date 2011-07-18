package Pithub::Orgs::Members;

# ABSTRACT: Github v3 Org Members API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method conceal

=over

=item *

Conceal a user's membership

    DELETE /orgs/:org/public_members/:user

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->conceal(
        org  => 'CPAN-API',
        user => 'plu',
    );

=back

=cut

sub conceal {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/orgs/%s/public_members/%s', delete $args{org}, delete $args{user} ),
        %args,
    );
}

=method delete

=over

=item *

Removing a user from this list will remove them from all teams and
they will no longer have any access to the organization's
repositories.

    DELETE /orgs/:org/members/:user

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->delete(
        org  => 'CPAN-API',
        user => 'plu',
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/orgs/%s/members/%s', delete $args{org}, delete $args{user} ),
        %args,
    );
}

=method is_member

=over

=item *

Check if a user is a member of an organization

    GET /orgs/:org/members/:user

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->is_member(
        org  => 'CPAN-API',
        user => 'plu',
    );

=back

=cut

sub is_member {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/orgs/%s/members/%s', delete $args{org}, delete $args{user} ),
        %args,
    );
}

=method is_public

=over

=item *

Get if a user is a public member

    GET /orgs/:org/public_members/:user

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->is_public(
        org  => 'CPAN-API',
        user => 'plu',
    );

=back

=cut

sub is_public {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/orgs/%s/public_members/%s', delete $args{org}, delete $args{user} ),
        %args,
    );
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

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->list( org => 'CPAN-API' );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/orgs/%s/members', delete $args{org} ),
        %args,
    );
}

=method list_public

=over

=item *

Members of an organization can choose to have their membership
publicized or not.

    GET /orgs/:org/public_members

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->list_public( org => 'CPAN-API' );

=back

=cut

sub list_public {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/orgs/%s/public_members', delete $args{org} ),
        %args,
    );
}

=method publicize

=over

=item *

Publicize a user's membership

    PUT /orgs/:org/public_members/:user

Examples:

    my $m = Pithub::Orgs::Members->new;
    my $result = $m->publicize(
        org  => 'CPAN-API',
        user => 'plu',
    );

=back

=cut

sub publicize {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org'  unless $args{org};
    croak 'Missing key in parameters: user' unless $args{user};
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/orgs/%s/public_members/%s', delete $args{org}, delete $args{user} ),
        %args,
    );
}

1;
