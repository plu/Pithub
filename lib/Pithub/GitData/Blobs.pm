package Pithub::GitData::Blobs;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::GitData::Blobs

=head1 METHODS

=head2 create

=over

=item *

Create a Blob

    POST /repos/:user/:repo/git/blobs

=back

Examples:

    my $result = $phub->git_data->blobs->create({ user => 'plu', repo => 'Pithub', data => { content => 'some blob' } });

=cut

sub create {
}

=head2 get

=over

=item *

Get a Blob

    GET /repos/:user/:repo/git/blobs/:sha

=back

Examples:

    my $result = $phub->git_data->blobs->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });

=cut

sub get {
}

__PACKAGE__->meta->make_immutable;

1;