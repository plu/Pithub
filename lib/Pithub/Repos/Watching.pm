package Pithub::Repos::Watching;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Repos::Watching

=head1 METHODS

=head2 is_watching

=over

=item *

Check if you are watching a repo

    GET /user/watched/:user/:repo

=back

Examples:

    my $result = $phub->repos->watching->is_watching({ repo => 'Pithub', user => 'plu' });

=cut

sub is_watching {
}

=head2 list_repos

=over

=item *

List repos being watched by a user

    GET /users/:user/watched

=item *

List repos being watched by the authenticated user

    GET /user/watched

=back

Examples:

    my $result = $phub->repos->watching->list_repos({ user => 'plu' });
    my $result = $phub->repos->watching->list_repos;

=cut

sub list_repos {
}

=head2 list_watchers

=over

=item *

List watchers

    GET /repos/:user/:repo/watchers

=back

Examples:

    my $result = $phub->repos->watching->list_watchers({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list_watchers {
}

=head2 start_watching

=over

=item *

Watch a repo

    PUT /user/watched/:user/:repo

=back

Examples:

    my $result = $phub->repos->watching->start_watching({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub start_watching {
}

=head2 stop_watching

=over

=item *

Stop watching a repo

    DELETE /user/watched/:user/:repo

=back

Examples:

    my $result = $phub->repos->watching->stop_watching({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub stop_watching {
}

__PACKAGE__->meta->make_immutable;

1;
