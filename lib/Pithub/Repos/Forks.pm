package Pithub::Repos::Forks;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Repos::Forks

=head1 METHODS

=head2 create

=over

=item *

Create a fork for the authenicated user.

    POST /repos/:user/:repo/forks

=back

Examples:

    my $result = $phub->repos->forks->create({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub create {
}

=head2 list

=over

=item *

List forks

    GET /repos/:user/:repo/forks

=back

Examples:

    my $result = $phub->repos->forks->list({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list {
}

__PACKAGE__->meta->make_immutable;

1;
