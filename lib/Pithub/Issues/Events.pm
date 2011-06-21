package Pithub::Issues::Events;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Issues::Events

=head1 METHODS

=head2 get

=over

=item *

Get a single event

    GET /repos/:user/:repo/issues/events/:id

=back

Examples:

    my $result = $phub->issues->events->get({ repo => 'Pithub', user => 'plu', event_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List events for an issue

    GET /repos/:user/:repo/issues/:issue_id/events

=item *

List events for a repository

    GET /repos/:user/:repo/issues/events

=back

Examples:

    my $result = $phub->issues->events->list({ repo => 'Pithub', user => 'plu', issue_id => 1 });
    my $result = $phub->issues->events->list({ repo => 'Pithub', user => 'plu' });

=cut

sub list {
}

__PACKAGE__->meta->make_immutable;

1;