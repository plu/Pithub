package Pithub::Orgs;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Members' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Teams' };

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

    my $result = $phub->orgs->get({ org => 'CPAN-API' });

=cut

sub get {
}

=head2 list

=over

=item *

List all public organizations for a user.

    GET /users/:user/orgs

=item *

List public and private organizations for the authenticated user.

    GET /user/orgs

=back

Examples:

    my $result = $phub->orgs->list({ user => 'plu' });

=cut

sub list {
}

=head2 update

=over

=item *

Edit an organization

    PATCH /orgs/:org

=back

Examples:

    my $result = $phub->orgs->update({ org => 'CPAN-API', data => { name => 'cpan-api' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
