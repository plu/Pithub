package Pithub::Gists;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };

=head1 NAME

Pithub::Gists

=head1 METHODS

=head2 create

=over

=item *

Create a gist

    POST /gists

=back

Examples:

    my $result = $phub->gists->create({ data => { description => 'foo bar' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a gist

    DELETE /gists/:id

=back

Examples:

    my $result = $phub->gists->delete({ gist_id => 784612 });

=cut

sub delete {
}

=head2 fork

=over

=item *

Fork a gist

    POST /gists/:id/fork

=back

Examples:

    my $result = $phub->gists->fork({ gist_id => 784612 });

=cut

sub fork {
}

=head2 get

=over

=item *

Get a single gist

    GET /gists/:id

=back

Examples:

    my $result = $phub->gists->get({ gist_id => 784612 });

=cut

sub get {
}

=head2 is_starred

=over

=item *

Check if a gist is starred

    GET /gists/:id/star

=back

Examples:

    my $result = $phub->gists->is_starred({ gist_id => 784612 });

=cut

sub is_starred {
}

=head2 list

=over

=item *

List a user’s gists:

    GET /users/:user/gists

=item *

List the authenticated user’s gists or if called anonymously, this will returns all public gists:

    GET /gists

=item *

List all public gists:

    GET /gists/public

=item *

List the authenticated user’s starred gists:

    GET /gists/starred

=back

Examples:

    my $result = $phub->gists->list({ user => 'plu' });

=cut

sub list {
}

=head2 star

=over

=item *

Star a gist

    PUT /gists/:id/star

=back

Examples:

    my $result = $phub->gists->star({ gist_id => 784612 });

=cut

sub star {
}

=head2 unstar

=over

=item *

Unstar a gist

    DELETE /gists/:id/star

=back

Examples:

    my $result = $phub->gists->unstar({ gist_id => 784612 });

=cut

sub unstar {
}

=head2 update

=over

=item *

Edit a gist

    PATCH /gists/:id

=back

Examples:

    my $result = $phub->gists->update({ gist_id => 784612, data => { description => 'bar foo' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
