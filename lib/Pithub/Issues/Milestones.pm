package Pithub::Issues::Milestones;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Issues::Milestones

=head1 METHODS

=head2 create

=over

=item *

Create a milestone

    POST /repos/:user/:repo/milestones

=back

Examples:

    my $result = $phub->issues->milestones->create({ repo => 'Pithub', user => 'plu', data => { title => 'some milestone' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a milestone

    DELETE /repos/:user/:repo/milestones/:id

=back

Examples:

    my $result = $phub->issues->milestones->delete({ repo => 'Pithub', user => 'plu', milestone_id => 1 });

=cut

sub delete {
}

=head2 get

=over

=item *

Get a single milestone

    GET /repos/:user/:repo/milestones/:id

=back

Examples:

    my $result = $phub->issues->milestones->get({ repo => 'Pithub', user => 'plu', milestone_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List milestones for an issue

    GET /repos/:user/:repo/milestones

=back

Examples:

    my $result = $phub->issues->milestones->list({ repo => 'Pithub', user => 'plu' });

=cut

sub list {
}

=head2 update

=over

=item *

Update a milestone

    PATCH /repos/:user/:repo/milestones/:id

=back

Examples:

    my $result = $phub->issues->milestones->update({ repo => 'Pithub', user => 'plu', data => { title => 'new title' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
