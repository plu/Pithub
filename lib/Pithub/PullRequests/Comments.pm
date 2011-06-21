package Pithub::PullRequests::Comments;

use Moose;
use namespace::autoclean;

=head1 NAME

Pithub::PullRequests::Comments

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /repos/:user/:repo/pulls/:id/comments

=back

Examples:

    my $result = $phub->pull_requests->comments->create({ repo => 'Pithub', user => 'plu', pull_request_id => 1, data => { body => 'some comment' } });

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/pulls/comments/:id

=back

Examples:

    my $result = $phub->pull_requests->comments->create({ repo => 'Pithub', user => 'plu', comment_id => 1 });

=cut

sub delete {
}

=head2 get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/pulls/comments/:id

=back

Examples:

    my $result = $phub->pull_requests->comments->list({ repo => 'Pithub', user => 'plu', comment_id => 1 });

=cut

sub get {
}

=head2 list

=over

=item *

List comments on a pull request

    GET /repos/:user/:repo/pulls/:id/comments

=back

Examples:

    my $result = $phub->pull_requests->comments->list({ repo => 'Pithub', user => 'plu', pull_request_id => 1 });

=cut

sub list {
}

=head2 update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/pulls/comments/:id

=back

Examples:

    my $result = $phub->pull_requests->comments->update({ repo => 'Pithub', user => 'plu', comment_id => 1, data => { body => 'some updated comment' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;