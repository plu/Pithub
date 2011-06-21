package Pithub::Repos::Keys;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Repos::Keys

=head1 METHODS

=head2 create

=over

=item *

Create

    POST /repos/:user/:repo/keys

=back

Examples:

    my $result = $phub->repos->keys->create({ user => 'plu', 'repo' => 'Pithub', key_id => 1, data => { title => 'some key' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete

    DELETE /repos/:user/:repo/keys/:id

=back

Examples:

    my $result = $phub->repos->keys->delete({ user => 'plu', 'repo' => 'Pithub', key_id => 1 });

=cut

sub delete {
}

=head2 get

=over

=item *

Get

    GET /repos/:user/:repo/keys/:id

=back

Examples:

    my $result = $phub->repos->keys->get({ user => 'plu', 'repo' => 'Pithub', key_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List

    GET /repos/:user/:repo/keys

=back

Examples:

    my $result = $phub->repos->keys->list({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list {
}

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo/keys/:id

=back

Examples:

    my $result = $phub->repos->keys->update({ user => 'plu', 'repo' => 'Pithub', key_id => 1, data => { title => 'some new title' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;