package Pithub::GitData::Trees;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::GitData::Trees

=head1 METHODS

=head2 create

=over

=item *

Create a Tree

    POST /repos/:user/:repo/git/trees

=back

Examples:

    my $result = $phub->git_data->trees->create({ user => 'plu', repo => 'Pithub', data => { base_tree => 'df21b2660fb6' } });

=cut

sub create {
}

=head2 get

=over

=item *

Get a Tree

    GET /repos/:user/:repo/git/trees/:sha

=item *

Get a Tree Recursively

    GET /repos/:user/:repo/git/trees/:sha?recursive=1

=back

Examples:

    my $result = $phub->git_data->trees->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' });
    my $result = $phub->git_data->trees->get({ user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6', recursive => 1 });

=cut

sub get {
}

__PACKAGE__->meta->make_immutable;

1;
