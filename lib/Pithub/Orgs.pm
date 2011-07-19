package Pithub::Orgs;

# ABSTRACT: Github v3 Orgs API

use Moo;
use Carp qw(croak);
use Pithub::Orgs::Members;
use Pithub::Orgs::Teams;
extends 'Pithub::Base';

=method get

=over

=item *

Get an organization

    GET /orgs/:org

Examples:

    my $o = Pithub::Orgs->new;
    my $result = $o->get( org => 'CPAN-API' );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/orgs/%s', delete $args{org} ),
        %args,
    );
}

=method list

=over

=item *

List all public organizations for a user.

    GET /users/:user/orgs

Examples:

    my $o = Pithub::Orgs->new;
    my $result = $o->list( user => 'plu' );

=item *

List public and private organizations for the authenticated user.

    GET /user/orgs

Examples:

    my $o = Pithub::Orgs->new;
    my $result = $o->list;

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = delete $args{user} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/users/%s/orgs', $user ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => '/user/orgs',
        %args,
    );
}

=method members

Provides access to L<Pithub::Orgs::Members>.

=cut

sub members {
    return shift->_create_instance('Pithub::Orgs::Members');
}

=method teams

Provides access to L<Pithub::Orgs::Teams>.

=cut

sub teams {
    return shift->_create_instance('Pithub::Orgs::Teams');
}

=method update

=over

=item *

Edit an organization

    PATCH /orgs/:org

Examples:

    my $o = Pithub::Orgs->new;
    my $result = $o->update(
        org  => 'CPAN-API',
        data => {
            billing_email => 'support@github.com',
            blog          => 'https://github.com/blog',
            company       => 'GitHub',
            email         => 'support@github.com',
            location      => 'San Francisco',
            name          => 'github',
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/orgs/%s', delete $args{org} ),
        %args,
    );
}

1;
