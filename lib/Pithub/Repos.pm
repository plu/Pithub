package Pithub::Repos;

# ABSTRACT: Github v3 Repos API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Collaborators' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Commits' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Downloads' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Forks' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Watching' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=method branches

=over

=item *

List Branches

    GET /repos/:user/:repo/branches

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->branches( user => 'plu', repo => 'Pithub' );

=back

=cut

sub branches {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/branches', $args{user}, $args{repo} ) );
}

=method contributors

=over

=item *

List contributors

    GET /repos/:user/:repo/contributors

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->contributors( user => 'plu', repo => 'Pithub' );

=back

=cut

sub contributors {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/contributors', $args{user}, $args{repo} ) );
}

=method create

=over

=item *

Create a new repository for the authenticated user.

    POST /user/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->create( data => { name => 'some-repo' } );

=item *

Create a new repository in this organization. The authenticated user
must be a member of this organization.

    POST /orgs/:org/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->create(
        org  => 'CPAN-API',
        data => { name => 'some-repo' }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    if ( my $org = $args{org} ) {
        return $self->request( POST => sprintf( '/orgs/%s/repos', $args{org} ), $args{data} );
    }
    else {
        return $self->request( POST => '/user/repos', $args{data} );
    }
}

=method get

=over

=item *

Get a repo

    GET /repos/:user/:repo

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->get( user => 'plu', repo => 'Pithub' );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s', $args{user}, $args{repo} ) );
}

=method languages

=over

=item *

List languages

    GET /repos/:user/:repo/languages

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->languages( user => 'plu', repo => 'Pithub' );

=back

=cut

sub languages {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/languages', $args{user}, $args{repo} ) );
}

=method list

=over

=item *

List repositories for the authenticated user.

    GET /user/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->list;

=item *

List public repositories for the specified user.

    GET /users/:user/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->list( user => 'plu' );

=item *

List repositories for the specified org.

    GET /orgs/:org/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->list( org => 'CPAN-API' );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/repos', $user ) );
    }
    elsif ( my $org = $args{org} ) {
        return $self->request( GET => sprintf( '/orgs/%s/repos', $org ) );
    }
    else {
        return $self->request( GET => '/user/repos' );
    }
}

=method tags

=over

=item *

List Tags

    GET /repos/:user/:repo/tags

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->tags( user => 'plu', repo => 'Pithub' );

=back

=cut

sub tags {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/tags', $args{user}, $args{repo} ) );
}

=method teams

=over

=item *

List Teams

    GET /repos/:user/:repo/teams

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->teams( user => 'plu', repo => 'Pithub' );

=back

=cut

sub teams {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/teams', $args{user}, $args{repo} ) );
}

=method update

=over

=item *

Edit

    PATCH /repos/:user/:repo

Examples:

    # update a repo for the authenticated user
    my $repos  = Pithub::Repos->new;
    my $result = $repos->update(
        repo => 'Pithub',
        data => { description => 'Github API v3' },
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s', $args{user}, $args{repo} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
