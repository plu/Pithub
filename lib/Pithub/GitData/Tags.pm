package Pithub::GitData::Tags;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::GitData::Tags

=head1 METHODS

=head2 create

=over

=item *

Create a Tag

    POST /repos/:user/:repo/git/tags

=back

Examples:

    my $result = $phub->git_data->tags->create({ user => 'plu', repo => 'Pithub', data => { message => 'some message' } });

=cut

sub create {
}

=head2 get

=over

=item *

Get a Tag

    GET /repos/:user/:repo/git/tags/:sha

=back

Examples:

    my $result = $phub->git_data->tags->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });

=cut

sub get {
}

__PACKAGE__->meta->make_immutable;

1;
