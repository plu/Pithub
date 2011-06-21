package Pithub::PullRequests;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };

=head1 NAME

Pithub::PullRequests

=head1 METHODS

=head2 commits

=over

=item *

List commits on a pull request

    GET /repos/:user/:repo/pulls/:id/commits

=back

Examples:

    my $result = $phub->pull_requests->commits({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });

=cut

sub commits {
}

=head2 create

=over

=item *

Create a pull request

    POST /repos/:user/:repo/pulls

=back

Examples:

    my $result = $phub->pull_requests->create({ user => 'plu', 'repo' => 'Pithub', data => { title => 'pull this' } });

=cut

sub create {
}

=head2 files

=over

=item *

List pull requests files

    GET /repos/:user/:repo/pulls/:id/files

=back

Examples:

    my $result = $phub->pull_requests->files({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });

=cut

sub files {
}

=head2 get

=over

=item *

Get a single pull request

    GET /repos/:user/:repo/pulls/:id

=back

Examples:

    my $result = $phub->pull_requests->get({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });

=cut

sub get {
}

=head2 is_merged

=over

=item *

Get if a pull request has been merged

    GET /repos/:user/:repo/pulls/:id/merge

=back

Examples:

    my $result = $phub->pull_requests->is_merged({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });

=cut

sub is_merged {
}

=head2 list

=over

=item *

List pull requests

    GET /repos/:user/:repo/pulls

=back

Examples:

    my $result = $phub->pull_requests->list({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub list {
}

=head2 merge

=over

=item *

Merge a pull request

    PUT /repos/:user/:repo/pulls/:id/merge

=back

Examples:

    my $result = $phub->pull_requests->merge({ user => 'plu', 'repo' => 'Pithub', pull_request_id => 1 });

=cut

sub merge {
}

=head2 update

=over

=item *

Update a pull request

    PATCH /repos/:user/:repo/pulls/:id

=back

Examples:

    my $result = $phub->pull_requests->update({ user => 'plu', 'repo' => 'Pithub', data => { title => 'pull that' } });

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
