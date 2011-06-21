package Pithub::GitData::Commits;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::GitData::Commits

=head1 METHODS

=head2 create

=over

=item *

Create a Commit

    POST /repos/:user/:repo/git/commits

=back

Examples:

    my $result = $phub->git_data->commits->create({ user => 'plu', repo => 'Pithub', data => { message => 'some message' } });

=cut

sub create {
}

=head2 get

=over

=item *

Get a Commit

    GET /repos/:user/:repo/git/commits/:sha

=back

Examples:

    my $result = $phub->git_data->commits->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });

=cut

sub get {
}

__PACKAGE__->meta->make_immutable;

1;