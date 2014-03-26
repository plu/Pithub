package Pithub::Orgs::Teams;

# ABSTRACT: Github v3 Org Teams API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method add_member

=over

In order to add a user to a team, the authenticated user must have
'admin' permissions to the team or be an owner of the org that the
team is associated with.

    PUT /teams/:id/members/:user

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->add_member(
        team_id => 1,
        user    => 'plu',
    );

=back

=cut

sub add_member {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: user'    unless $args{user};
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/teams/%s/members/%s', delete $args{team_id}, delete $args{user} ),
        %args,
    );
}

=method add_repo

=over

In order to add a repo to a team, the authenticated user must be
an owner of the org that the team is associated with.

    PUT /teams/:id/repos/:repo

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->add_repo(
        team_id => 1,
        repo    => 'some_repo',
        org => 'our_organization',
    );

=back

=cut

sub add_repo {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: repo'    unless $args{repo};
    croak 'Missing key in parameters: org'     unless $args{org};
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/teams/%s/repos/%s/%s',
            delete $args{team_id},
            delete $args{org},
            delete $args{repo} ),
        %args,
    );
}

=method create

=over

In order to create a team, the authenticated user must be an
owner of the given organization.

    POST /orgs/:org/teams

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->create(
        org  => 'CPAN-API',
        data => {
            name       => 'new team',
            permission => 'push',
            repo_names => ['github/dotfiles']
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'POST',
        path   => sprintf( '/orgs/%s/teams', delete $args{org} ),
        %args,
    );
}

=method delete

=over

In order to delete a team, the authenticated user must be an owner
of the org that the team is associated with.

    DELETE /teams/:id

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->delete( team_id => 1 );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/teams/%s', delete $args{team_id} ),
        %args,
    );
}

=method get

=over

Get team

    GET /teams/:id

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->get( team_id => 1 );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/teams/%s', delete $args{team_id} ),
        %args,
    );
}

=method has_repo

=over

Get team repo

    GET /teams/:id/repos/:repo

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->has_repo(
        team_id => 1,
        repo    => 'some_repo',
    );

=back

=cut

sub has_repo {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: repo'    unless $args{repo};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/teams/%s/repos/%s', delete $args{team_id}, delete $args{repo} ),
        %args,
    );
}

=method is_member

=over

In order to get if a user is a member of a team, the authenticated
user must be a member of the team.

    GET /teams/:id/members/:user

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->is_member(
        team_id => 1,
        user    => 'plu',
    );

=back

=cut

sub is_member {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: user'    unless $args{user};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/teams/%s/members/%s', delete $args{team_id}, delete $args{user} ),
        %args,
    );
}

=method list

=over

List teams

    GET /orgs/:org/teams

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->list( org => 'CPAN-API' );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/orgs/%s/teams', delete $args{org} ),
        %args,
    );
}

=method list_members

=over

In order to list members in a team, the authenticated user must be
a member of the team.

    GET /teams/:id/members

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->list_members( team_id => 1 );

=back

=cut

sub list_members {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/teams/%s/members', delete $args{team_id} ),
        %args,
    );
}

=method list_repos

=over

List team repos

    GET /teams/:id/repos

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->list_repos( team_id => 1 );

=back

=cut

sub list_repos {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/teams/%s/repos', delete $args{team_id} ),
        %args,
    );
}

=method remove_member

=over

In order to remove a user from a team, the authenticated user must
have 'admin' permissions to the team or be an owner of the org that
the team is associated with. NOTE: This does not delete the user,
it just remove them from the team.

    DELETE /teams/:id/members/:user

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->remove_member(
        team_id => 1,
        user    => 'plu',
    );

=back

=cut

sub remove_member {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: user'    unless $args{user};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/teams/%s/members/%s', delete $args{team_id}, delete $args{user} ),
        %args,
    );
}

=method remove_repo

=over

In order to remove a repo from a team, the authenticated user must be
an owner of the org that the team is associated with.

    DELETE /teams/:id/repos/:repo

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->remove_repo(
        team_id => 1,
        repo    => 'some_repo',
    );

=back

=cut

sub remove_repo {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: repo'    unless $args{repo};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/teams/%s/repos/%s', delete $args{team_id}, delete $args{repo} ),
        %args,
    );
}

=method update

=over

In order to edit a team, the authenticated user must be an owner
of the org that the team is associated with.

    PATCH /teams/:id

Examples:

    my $t = Pithub::Orgs::Teams->new;
    my $result = $t->update(
        team_id => 1,
        data    => {
            name       => 'new team name',
            permission => 'push',
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: team_id' unless $args{team_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/teams/%s', delete $args{team_id} ),
        %args,
    );
}

1;
