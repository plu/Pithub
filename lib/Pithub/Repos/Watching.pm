package Pithub::Repos::Watching;

# ABSTRACT: Github v3 Repo Watching API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method is_watching

=over

=item *

Check if you are watching a repo

    GET /user/watched/:user/:repo

Examples:

    my $w = Pithub::Repos::Watching->new;
    my $result = $w->is_watching(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub is_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

=method list_repos

=over

=item *

List repos being watched by a user

    GET /users/:user/watched

Examples:

    my $w = Pithub::Repos::Watching->new;
    my $result = $w->list_repos( user => 'plu' );

=item *

List repos being watched by the authenticated user

    GET /user/watched

Examples:

    my $w = Pithub::Repos::Watching->new;
    my $result = $w->list_repos;

=back

=cut

sub list_repos {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/watched', $args{user} ) );
    }
    return $self->request( GET => '/user/watched' );
}

=method list

=over

=item *

List watchers

    GET /repos/:user/:repo/watchers

Examples:

    my $w = Pithub::Repos::Watching->new;
    my $result = $w->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/watchers', $args{user}, $args{repo} ) );
}

=method start_watching

=over

=item *

Watch a repo

    PUT /user/watched/:user/:repo

Examples:

    my $w = Pithub::Repos::Watching->new;
    my $result = $w->start_watching(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=cut

sub start_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

=method stop_watching

=over

=item *

Stop watching a repo

    DELETE /user/watched/:user/:repo

Examples:

    my $w = Pithub::Repos::Watching->new;
    my $result = $w->stop_watching(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=cut

sub stop_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;
