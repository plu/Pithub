package Pithub::Repos::Collaborators;

# ABSTRACT: Github v3 Repo Collaborators API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method add

=over

=item *

Add collaborator

    PUT /repos/:user/:repo/collaborators/:user

Examples:

    my $c = Pithub::Repos::Collaborators->new;
    my $result = $c->add(
        user         => 'plu',
        repo         => 'Pithub',
        collaborator => 'rbo',
    );

=back

=cut

sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: collaborator' unless $args{collaborator};
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/repos/%s/%s/collaborators/%s', $args{user}, $args{repo}, $args{collaborator} ) );
}

=method is_collaborator

=over

=item *

Get

    GET /repos/:user/:repo/collaborators/:user

Examples:

    my $c = Pithub::Repos::Collaborators->new;
    my $result = $c->is_collaborator(
        user         => 'plu',
        repo         => 'Pithub',
        collaborator => 'rbo',
    );

    if ( $result->is_success ) {
        print "rbo is added as collaborator to Pithub\n";
    }
    elsif ( $result->code == 404 ) {
        print "rbo is not added as collaborator to Pithub\n";
    }

=back

=cut

sub is_collaborator {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: collaborator' unless $args{collaborator};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/collaborators/%s', $args{user}, $args{repo}, $args{collaborator} ) );
}

=method list

=over

=item *

List

    GET /repos/:user/:repo/collaborators

Examples:

    my $c = Pithub::Repos::Collaborators->new;
    my $result = $c->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/collaborators', $args{user}, $args{repo} ) );
}

=method remove

=over

=item *

Remove collaborator

    DELETE /repos/:user/:repo/collaborators/:user

Examples:

    my $c = Pithub::Repos::Collaborators->new;
    my $result = $c->remove(
        user         => 'plu',
        repo         => 'Pithub',
        collaborator => 'rbo',
    );

=back

=cut

sub remove {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: collaborator' unless $args{collaborator};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/collaborators/%s', $args{user}, $args{repo}, $args{collaborator} ) );
}

__PACKAGE__->meta->make_immutable;

1;
