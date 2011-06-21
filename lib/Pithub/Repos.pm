package Pithub::Repos;

use Moose;
use namespace::autoclean;
with 'MooseX::Role::BuildInstanceOf' => { target => '::Collaborators' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Commits' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Downloads' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Forks' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Watching' };

=head1 NAME

Pithub::Repos

=head1 METHODS

=head2 branches

=over

=item *

List Branches

    GET /repos/:user/:repo/branches

=back

Examples:

    my $result = $phub->repos->branches({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub branches {
}

=head2 contributors

=over

=item *

List contributors

    GET /repos/:user/:repo/contributors

=back

Examples:

    my $result = $phub->repos->contributors({ user => 'plu', repo => 'Pithub' });

=cut

sub contributors {
}

=head2 create

=over

=item *

Create a new repository for the authenticated user.

    POST /user/repos

=item *

Create a new repository in this organization. The authenticated user must be a member of :org.

    POST /orgs/:org/repos

=back

Examples:

    my $result = $phub->repos->create({ user => 'plu', data => { name => 'some-thing' } });

=cut

sub create {
}

=head2 get

=over

=item *

Get a repo

    GET /repos/:user/:repo

=back

Examples:

    my $result = $phub->repos->get({ user => 'plu', repo => 'Pithub' });

=cut

sub get {
}

=head2 languages

=over

=item *

List languages

    GET /repos/:user/:repo/languages

=back

Examples:

    my $result = $phub->repos->languages({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub languages {
}

=head2 list

=over

=item *

List repositories for the authenticated user.

    GET /user/repos

=item *

List public repositories for the specified user.

    GET /users/:user/repos

=item *

List repositories for the specified org.

    GET /orgs/:org/repos

=back

Examples:

    my $result = $phub->repos->list({ user => 'plu' });

=cut

sub list {
}

=head2 tags

=over

=item *

List Tags

    GET /repos/:user/:repo/tags

=back

Examples:

    my $result = $phub->repos->tags({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub tags {
}

=head2 teams

=over

=item *

List Teams

    GET /repos/:user/:repo/teams

=back

Examples:

    my $result = $phub->repos->teams({ user => 'plu', 'repo' => 'Pithub' });

=cut

sub teams {
}

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo

=back

Examples:

    my $result = $phub->repos->update({ user => 'plu', repo => 'Pithub', data => { name => 'Gearman-Driver' }});

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
