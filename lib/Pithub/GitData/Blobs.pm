package Pithub::GitData::Blobs;

# ABSTRACT: Github v3 Git Data Blobs API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a Blob

    POST /repos/:user/:repo/git/blobs

Examples:

    $result = $p->git_data->blobs->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            content  => 'Content of the blob',
            encoding => 'utf-8',
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/git/blobs', $args{user}, $args{repo} ), $args{data} );
}

=method get

=over

=item *

Get a Blob

    GET /repos/:user/:repo/git/blobs/:sha

Examples:

    $result = $p->git_data->blobs->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/git/blobs/%s', $args{user}, $args{repo}, $args{sha} ) );
}

__PACKAGE__->meta->make_immutable;

1;
