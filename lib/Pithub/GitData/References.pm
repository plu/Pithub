package Pithub::GitData::References;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::GitData::References

=head1 METHODS

=head2 create

=over

=item *

Create a Reference

    POST /repos/:user/:repo/git/refs

=back

Examples:

    $result = $p->git_data->references->create( user => 'plu', repo => 'Pithub', { data => { ref => 'tags/v1.0', sha => 'df21b2660fb6' } } );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/git/refs', $args{user}, $args{repo} ), $args{data} );
}

=head2 get

=over

=item *

Get a Reference

    GET /repos/:user/:repo/git/refs/:ref

=back

Examples:

    $result = $p->git_data->references->get( user => 'plu', repo => 'Pithub', ref => 'heads/master' );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: ref' unless $args{ref};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/git/refs/%s', $args{user}, $args{repo}, $args{ref} ) );
}

=head2 list

=over

=item *

Get all References

    GET /repos/:user/:repo/git/refs

This will return an array of all the references on the system,
including things like notes and stashes if they exist on the server.
Anything in the namespace, not just heads and tags, though that
would be the most common.

=item *

You can also request a sub-namespace. For example, to get all the
tag references, you can call:

    GET /repos/:user/:repo/git/refs/tags

=back

Examples:

    $result = $p->git_data->references->list( user => 'plu', repo => 'Pithub' );
    $result = $p->git_data->references->list( user => 'plu', repo => 'Pithub', ref => 'tags' );

=cut

sub list {
}

=head2 update

=over

=item *

Update a Reference

    PATCH /repos/:user/:repo/git/refs/:ref

=back

Examples:

    $result = $p->git_data->references->update( user => 'plu', repo => 'Pithub', ref => 'tags/v1.0', data => { sha => 'df21b2660fb6' } );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: ref' unless $args{ref};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/git/refs/%s', $args{user}, $args{repo}, $args{ref} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
