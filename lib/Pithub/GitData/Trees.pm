package Pithub::GitData::Trees;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::GitData::Trees

=head1 METHODS

=head2 create

=over

=item *

Create a Tree

    POST /repos/:user/:repo/git/trees

=back

Examples:

    $result = $p->git_data->trees->create( user => 'plu', repo => 'Pithub', data => { base_tree => 'df21b2660fb6' } );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/git/trees', $args{user}, $args{repo} ), $args{data} );
}

=head2 get

=over

=item *

Get a Tree

    GET /repos/:user/:repo/git/trees/:sha

=item *

Get a Tree Recursively

    GET /repos/:user/:repo/git/trees/:sha?recursive=1

=back

Examples:

    $result = $p->git_data->trees->get( user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6' );
    $result = $p->git_data->trees->get( user => 'plu', repo => 'Pithub', sha => 'df21b2660fb6', recursive => 1 );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/git/trees/%s', $args{user}, $args{repo}, $args{sha} ) );
}

__PACKAGE__->meta->make_immutable;

1;
