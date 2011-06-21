package Pithub::Gists::Comments;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Gists::Comments

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /gists/:gist_id/comments

=back

Examples:

    my $result = $phub->gists->comments->create({ gist_id => 1, data => { body => 'some comment' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a comment

    DELETE /gists/comments/:id

=back

Examples:

    my $result = $phub->gists->comments->delete({ comment_id => 1 });

=cut

sub delete {
}

=head2 get

=over

=item *

Get a single comment

    GET /gists/comments/:id

=back

Examples:

    my $result = $phub->gists->comments->get({ comment_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List comments on a gist

    GET /gists/:gist_id/comments

=back

Examples:

    my $result = $phub->gists->comments->list({ gist_id => 1 });

=cut

sub list {
}

=head2 update

=over

=item *

Edit a comment

    PATCH /gists/comments/:id

=back

Examples:

    my $result = $phub->gists->comments->update({ comment_id => 1, data => { body => 'some comment' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;