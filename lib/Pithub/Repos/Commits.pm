package Pithub::Repos::Commits;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::Repos::Commits

=head1 METHODS

=head2 create_comment

=over

=item *

Create a commit comment

    POST /repos/:user/:repo/commits/:sha/comments

=back

Examples:

    my $result = $phub->repos->commits->create_comment({ user => 'plu', 'repo' => 'Pithub', sha => 'df21b2660fb6', data => { body => 'some comment' } });

=cut

sub create_comment {
}

=head2 delete_comment

=over

=item *

Delete a commit comment

    DELETE /repos/:user/:repo/comments/:id

=back

Examples:

    my $result = $phub->repos->commits->create_comment({ user => 'plu', 'repo' => 'Pithub', comment_id => 1 });

=cut

sub delete_comment {
}

=head2 get

=over

=item *

Get a single commit

    GET /repos/:user/:repo/commits/:sha

=back

Examples:

    my $result = $phub->repos->commits->get({ user => 'plu', 'repo' => 'Pithub', sha => 'df21b2660fb6' });

=cut

sub get {
}

=head2 get_comment

=over

=item *

Get a single commit comment

    GET /repos/:user/:repo/comments/:id

=back

Examples:

    my $result = $phub->repos->commits->get_comment({ user => 'plu', 'repo' => 'Pithub', comment_id => 1 });

=cut

sub get_comment {
}

=head2 list

=over

=item *

List commits on a repository

    GET /repos/:user/:repo/commits

=back

Examples:

    my $result = $phub->repos->commits->list({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list {
}

=head2 list_comments

=over

=item *

List commit comments for a repository

Commit Comments leverage these custom mime types. You can read more
about the use of mimes types in the API here. TODO: Link github API

    GET /repos/:user/:repo/comments

=item *

List comments for a single commit

    GET /repos/:user/:repo/commits/:sha/comments

=back

Examples:

    my $result = $phub->repos->commits->list_comments({ user => 'plu', 'repo' => 'Pithub' });
    my $result = $phub->repos->commits->list_comments({ user => 'plu', 'repo' => 'Pithub', sha => 'df21b2660fb6' });

=cut

sub list_comments {
}

=head2 update_comment

=over

=item *

Update a commit comment

    PATCH /repos/:user/:repo/comments/:id

=back

Examples:

    my $result = $phub->repos->commits->update_comment({ user => 'plu', 'repo' => 'Pithub', comment_id => 1, data => { body => 'updated comment' } });

=cut

sub update_comment {
}

__PACKAGE__->meta->make_immutable;

1;