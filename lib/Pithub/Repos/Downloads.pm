package Pithub::Repos::Downloads;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Repos::Downloads

=head1 METHODS

=head2 create

=over

=item *

Create a new download

    PUT /repos/:user/:repo/downloads/:id

TODO: what is :id here?

=back

Examples:

    my $result = $phub->repos->downloads->create({ user => 'plu', 'repo' => 'Pithub', { name => 'some download' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a download

    DELETE /repos/:user/:repo/downloads/:id

=back

Examples:

    my $result = $phub->repos->downloads->delete({ user => 'plu', 'repo' => 'Pithub', download_id => 1 });

=cut

sub delete {
}

=head2 get

=over

=item *

Get a single download

    GET /repos/:user/:repo/downloads/:id

=back

Examples:

    my $result = $phub->repos->downloads->list({ user => 'plu', 'repo' => 'Pithub', download_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List downloads for a repository

    GET /repos/:user/:repo/downloads

=back

Examples:

    my $result = $phub->repos->downloads->list({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list {
}

__PACKAGE__->meta->make_immutable;

1;