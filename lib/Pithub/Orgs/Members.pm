package Pithub::Orgs::Members;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Orgs::Members

=head1 METHODS

=head2 conceal

=over

=item *

Conceal a user's membership

    DELETE /orgs/:org/public_members/:user

=back

Examples:

    my $result = $p->orgs->members->conceal( org => 'CPAN-API', user => 'plu' );

=cut

sub conceal {
}

=head2 delete

=over

=item *

Removing a user from this list will remove them from all teams and
they will no longer have any access to the organization’s
repositories.

    DELETE /orgs/:org/members/:user

=back

Examples:

    my $result = $p->orgs->members->delete( org => 'CPAN-API', user => 'plu' );

=cut

sub delete {
}

=head2 is_member

=over

=item *

Check if a user is a member of an organization

    GET /orgs/:org/members/:user

=back

Examples:

    my $result = $p->orgs->members->is_member( org => 'CPAN-API', user => 'plu' );

=cut

sub is_member {
}

=head2 is_public

=over

=item *

Get if a user is a public member

    GET /orgs/:org/public_members/:user

=back

Examples:

    my $result = $p->orgs->members->is_public( org => 'CPAN-API', user => 'plu' );

=cut

sub is_public {
}

=head2 list

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

    my $result = $p->orgs->members->list( org => 'CPAN-API' );

=cut

sub list {
}

=head2 list_public

=over

=item *

Members of an organization can choose to have their membership
publicized or not.

    GET /orgs/:org/public_members

=back

Examples:

    my $result = $p->orgs->members->list_public( org => 'CPAN-API' );

=cut

sub list_public {
}

=head2 publicize

=over

=item *

Publicize a user's membership

    PUT /orgs/:org/public_members/:user

=back

Examples:

    my $result = $p->orgs->members->publicize( org => 'CPAN-API', user => 'plu' );

=cut

sub publicize {
}

__PACKAGE__->meta->make_immutable;

1;
