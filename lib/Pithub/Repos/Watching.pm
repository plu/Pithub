package Pithub::Repos::Watching;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Repos::Watching

=head1 METHODS

=head2 is_watching

=over

=item *

Check if you are watching a repo

    GET /user/watched/:user/:repo

=back

Examples:

    $result = $p->repos->watching->is_watching(
        repo => 'Pithub',
        user => 'plu',
    );

=cut

sub is_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

=head2 list_repos

=over

=item *

List repos being watched by a user

    GET /users/:user/watched

Examples:

    $result = $p->repos->watching->list_repos( user => 'plu' );

=item *

List repos being watched by the authenticated user

    GET /user/watched

Examples:

    $result = $p->repos->watching->list_repos;

=back

=cut

sub list_repos {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/watched', $args{user} ) );
    }
    return $self->request( GET => '/user/watched' );
}

=head2 list

=over

=item *

List watchers

    GET /repos/:user/:repo/watchers

=back

Examples:

    $result = $p->repos->watching->list(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/watchers', $args{user}, $args{repo} ) );
}

=head2 start_watching

=over

=item *

Watch a repo

    PUT /user/watched/:user/:repo

=back

Examples:

    $result = $p->repos->watching->start_watching(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub start_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

=head2 stop_watching

=over

=item *

Stop watching a repo

    DELETE /user/watched/:user/:repo

=back

Examples:

    $result = $p->repos->watching->stop_watching(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub stop_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;
