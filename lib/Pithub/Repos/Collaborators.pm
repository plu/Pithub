package Pithub::Repos::Collaborators;

# ABSTRACT: Github v3 Repo Collaborators API

use Moo;
use Carp qw(croak);
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
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/repos/%s/%s/collaborators/%s', delete $args{user}, delete $args{repo}, delete $args{collaborator} ),
        %args,
    );
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
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/collaborators/%s', delete $args{user}, delete $args{repo}, delete $args{collaborator} ),
        %args,
    );
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
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/collaborators', delete $args{user}, delete $args{repo} ),
        %args,
    );
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
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/collaborators/%s', delete $args{user}, delete $args{repo}, delete $args{collaborator} ),
        %args
    );
}

1;
