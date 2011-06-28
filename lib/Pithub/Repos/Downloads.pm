package Pithub::Repos::Downloads;

# ABSTRACT: Github v3 Repo Downloads API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a new download

    POST /repos/:user/:repo/downloads

Examples:

    $result = $p->repos->downloads->create(
        user => 'plu',
        repo => 'Pithub',
        data => { name => 'some download' },
    );

=back

TODO: Creating downloads is currently not supported!

=cut

sub create {
    croak 'not supported';
}

=method delete

=over

=item *

Delete a download

    DELETE /repos/:user/:repo/downloads/:id

Examples:

    $result = $p->repos->downloads->delete(
        user        => 'plu',
        repo        => 'Pithub',
        download_id => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: download_id' unless $args{download_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/downloads/%s', $args{user}, $args{repo}, $args{download_id} ) );
}

=method get

=over

=item *

Get a single download

    GET /repos/:user/:repo/downloads/:id

Examples:

    $result = $p->repos->downloads->get(
        user        => 'plu',
        repo        => 'Pithub',
        download_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: download_id' unless $args{download_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/downloads/%s', $args{user}, $args{repo}, $args{download_id} ) );
}

=method list

=over

=item *

List downloads for a repository

    GET /repos/:user/:repo/downloads

Examples:

    $result = $p->repos->downloads->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/downloads', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;
