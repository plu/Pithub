package Pithub::Orgs::Teams;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Orgs::Teams

=head1 METHODS

=head2 add_member

=over

In order to add a user to a team, the authenticated user must have
'admin' permissions to the team or be an owner of the org that the
team is associated with.

    PUT /teams/:id/members/:user

=back

Examples:

    $result = $p->orgs->teams->add_member(
        team_id => 1,
        user    => 'plu',
    );

=cut

sub add_member {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: user'    unless $args{user};
    return $self->request( PUT => sprintf( '/teams/%d/members/%s', $args{team_id}, $args{user} ) );
}

=head2 add_repo

=over

In order to add a repo to a team, the authenticated user must be
an owner of the org that the team is associated with.

    PUT /teams/:id/repos/:repo

=back

Examples:

    $result = $p->orgs->teams->add_repo(
        team_id => 1,
        repo    => 'some_repo',
    );

=cut

sub add_repo {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: repo'    unless $args{repo};
    return $self->request( PUT => sprintf( '/teams/%d/repos/%s', $args{team_id}, $args{repo} ) );
}

=head2 create

=over

In order to create a team, the authenticated user must be an
owner of the given organization.

    POST /orgs/:org/teams

=back

Examples:

    $result = $p->orgs->teams->create(
        org  => 'CPAN-API',
        data => {
            name       => 'new team',
            permission => 'push',
            repo_names => ['github/dotfiles']
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => sprintf( '/orgs/%s/teams', $args{org} ), $args{data} );
}

=head2 delete

=over

In order to delete a team, the authenticated user must be an owner
of the org that the team is associated with.

    DELETE /teams/:id

=back

Examples:

    my $result = $p->orgs->teams->delete( team_id => 1 );

=cut

sub delete {
}

=head2 get

=over

Get team

    GET /teams/:id

=back

Examples:

    my $result = $p->orgs->teams->get( team_id => 1 );

=cut

sub get {
}

=head2 get_repo

=over

Get team repo

    GET /teams/:id/repos/:repo

=back

Examples:

    my $result = $p->orgs->teams->get( team_id => 1, repo => 'some_repo' );

=cut

sub get_repo {
}

=head2 is_member

=over

In order to get if a user is a member of a team, the authenticated
user must be a member of the team.

    GET /teams/:id/members/:user

=back

Examples:

    my $result = $p->orgs->teams->is_member( team_id => 1, user => 'plu' );

=cut

sub is_member {
}

=head2 list

=over

List teams

    GET /orgs/:org/teams

=back

Examples:

    my $result = $p->orgs->teams->list( org => 'CPAN-API' );

=cut

sub list {
}

=head2 list_members

=over

In order to list members in a team, the authenticated user must be
a member of the team.

    GET /teams/:id/members

=back

Examples:

    my $result = $p->orgs->teams->list_members( team_id => 1 );

=cut

sub list_members {
}

=head2 list_repos

=over

List team repos

    GET /teams/:id/repos

=back

Examples:

    my $result = $p->orgs->teams->list_repos( team_id => 1 );

=cut

sub list_repos {
}

=head2 remove_member

=over

In order to remove a user from a team, the authenticated user must
have 'admin' permissions to the team or be an owner of the org that
the team is associated with. NOTE: This does not delete the user,
it just remove them from the team.

    DELETE /teams/:id/members/:user

=back

Examples:

    my $result = $p->orgs->teams->remove_member( team_id => 1, user => 'plu' );

=cut

sub remove_member {
}

=head2 remove_repo

=over

In order to remove a repo from a team, the authenticated user must be
an owner of the org that the team is associated with.

    DELETE /teams/:id/repos/:repo

=back

Examples:

    my $result = $p->orgs->teams->remove_repo( team_id => 1, repo => 'some_repo' );

=cut

sub remove_repo {
}

=head2 update

=over

In order to edit a team, the authenticated user must be an owner
of the org that the team is associated with.

    PATCH /teams/:id

=back

Examples:

    my $result = $p->orgs->teams->update( team_id => 1, data => { name => 'new team name' } );

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
