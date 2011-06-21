package Pithub::Users::Keys;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Users::Keys

=head1 METHODS

=head2 create

=over

=item *

Create a public key

    POST /user/keys

=back

Examples:

    my $result = $phub->users->keys->create({ data => { title => 'some key' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a public key

    DELETE /user/keys/:id

=back

Examples:

    my $result = $phub->users->keys->delete({ key_id => 1 });

=cut

sub delete {
}

=head2 get

=over

=item *

Get a single public key

    GET /user/keys/:id

=back

Examples:

    my $result = $phub->users->keys->get({ key_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List public keys for a user

    GET /user/keys

=back

Examples:

    my $result = $phub->users->keys->list;

=cut

sub list {
}

=head2 update

=over

=item *

Update a public key

    PATCH /user/keys/:id

=back

Examples:

    my $result = $phub->users->keys->update({ data => { title => 'some key' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
