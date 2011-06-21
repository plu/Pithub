package Pithub::GitData::References;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::GitData::References

=head1 METHODS

=head2 create

=over

=item *

Create a Reference

    POST /repos/:user/:repo/git/refs

=back

Examples:

    my $result = $phub->git_data->references->create({ user => 'plu', repo => 'Pithub', { data => { ref => 'tags/v1.0', sha => 'df21b2660fb6' } } });

=cut

sub create {
}

=head2 get

=over

=item *

Get a Reference

    GET /repos/:user/:repo/git/refs/:ref

=back

Examples:

    my $result = $phub->git_data->references->get({ user => 'plu', repo => 'Pithub', ref => 'heads/master' });

=cut

sub get {
}

=head2 list

=over

=item *

Get all References

    GET /repos/:user/:repo/git/refs

This will return an array of all the references on the system,
including things like notes and stashes if they exist on the server.
Anything in the namespace, not just heads and tags, though that
would be the most common.

=item *

You can also request a sub-namespace. For example, to get all the
tag references, you can call:

    GET /repos/:user/:repo/git/refs/tags

=back

Examples:

    my $result = $phub->git_data->references->list({ user => 'plu', repo => 'Pithub' });
    my $result = $phub->git_data->references->list({ user => 'plu', repo => 'Pithub', ref => 'tags' });

=cut

sub list {
}

=head2 update

=over

=item *

Update a Reference

    PATCH /repos/:user/:repo/git/refs/:ref

=back

Examples:

    my $result = $phub->git_data->references->update({ user => 'plu', repo => 'Pithub', { data => { ref => 'tags/v1.0', sha => 'df21b2660fb6' } } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
