package Pithub::Repos::Collaborators;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Repos::Collaborators

=head1 METHODS

=head2 add

=over

=item *

Add collaborator

    PUT /repos/:user/:repo/collaborators/:user

=back

Examples:

    my $result = $phub->repos->collaborators->add({ user => 'plu', 'repo' => 'Pithub', collaborator => 'rbo' });

=cut

sub add {
}

=head2 is_collaborator

=over

=item *

Get

    GET /repos/:user/:repo/collaborators/:user

=back

Examples:

    my $result = $phub->repos->collaborators->is_collaborator({ user => 'plu', 'repo' => 'Pithub', collaborator => 'rbo' });

=cut

sub is_collaborator {
}

=head2 list

=over

=item *

List

    GET /repos/:user/:repo/collaborators

=back

Examples:

    my $result = $phub->repos->collaborators->list({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list {
}

=head2 remove

=over

=item *

Remove collaborator

    DELETE /repos/:user/:repo/collaborators/:user

=back

Examples:

    my $result = $phub->repos->collaborators->remove({ user => 'plu', 'repo' => 'Pithub', collaborator => 'rbo' });

=cut

sub remove {
}

__PACKAGE__->meta->make_immutable;

1;
