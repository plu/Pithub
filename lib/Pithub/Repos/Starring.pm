package Pithub::Repos::Starring;

# ABSTRACT: Github v3 Repo Starring API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method has_starred

=over

=item *

Check if you are starring a repository.

Requires for the user to be authenticated.

    GET /user/starred/:user/:repo

Examples:

    my $s = Pithub::Repos::Starring->new;
    my $result = $s->has_starred(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub has_starred {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/user/starred/%s/%s', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method list

=over

=item *

List all stargazers of a repository

    GET /repos/:user/:repo/stargazers

Examples:

    my $s = Pithub::Repos::Starring->new;
    my $result = $s->list(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/stargazers', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method list_repos

=over

=item *

List repositories being starred by a user.

    GET /users/:user/starred

Examples:

    my $s = Pithub::Repos::Starring->new;
    my $result = $s->list_repos(
        user => 'plu',
    );

=item *

List repos being starred by the authenticated user

    GET /user/starred

Examples:

    my $s = Pithub::Repos::Starring->new;
    my $result = $s->list_repos;

=back

=cut

sub list_repos {
    my ( $self, %args ) = @_;
    if ( my $user = delete $args{user} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/users/%s/starred', $user ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => '/user/starred',
        %args,
    );
}

=method star

=over

=item *

Star a repository.

Requires for the user to be authenticated.

    PUT /user/starred/:user/:repo

Examples:

    my $s = Pithub::Repos::Starring->new;
    my $result = $s->star(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub star {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/user/starred/%s/%s', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method unstar

=over

=item *

Unstar a repository.

Requires for the user to be authenticated.

    DELETE /user/starred/:user/:repo

Examples:

    my $s = Pithub::Repos::Starring->new;
    my $result = $s->unstar(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub unstar {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/user/starred/%s/%s', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

1;
