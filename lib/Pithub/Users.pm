package Pithub::Users;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Emails' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Followers' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };

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

    my $result = $phub->users->get({ user => 'plu' });

=cut

sub get {
}

=head2 update

=over

=item *

Update the authenticated user

    PATCH /user

=back

Examples:

    my $result = $phub->users->update({ email => 'plu@pqpq.de' });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
