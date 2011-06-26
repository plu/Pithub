package Pithub::Orgs;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Members' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Teams' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub::Orgs

=head1 METHODS

=head2 get

=over

=item *

Get an organization

    GET /orgs/:org

=back

Examples:

    $result = $p->orgs->get( org => 'CPAN-API' );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request( GET => sprintf( '/orgs/%s', $args{org} ) );
}

=head2 list

=over

=item *

List all public organizations for a user.

    GET /users/:user/orgs

Examples:

    $result = $p->orgs->list( user => 'plu' );

=item *

List public and private organizations for the authenticated user.

    GET /user/orgs

=back

Examples:

    $result = $p->orgs->list;

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/orgs', $args{user} ) );
    }
    return $self->request( GET => '/user/orgs' );
}

=head2 update

=over

=item *

Edit an organization

    PATCH /orgs/:org

=back

Examples:

    my $result = $p->orgs->update( org => 'CPAN-API', data => { name => 'cpan-api' } );

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
