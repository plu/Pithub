package Pithub::Repos::Branches;
our $VERSION = '0.01037';
# ABSTRACT: Github v3 Repo Commits API

use Moo;
use Carp qw( croak );
extends 'Pithub::Base';

=method get

=over

=item *

Get a single branch

    GET /repos/:user/:repo/branches/:branch

Examples:

    my $b = Pithub::Repos::Branches->new;
    my $result = $b->get(
        user => 'plu',
        repo => 'Pithub',
        branch  => 'master',
    );

See also L<branches> to get a list of all branches.

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: branch' unless $args{branch};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/branches/%s', delete $args{user}, delete $args{repo}, delete $args{branch} ),
        %args,
    );
}

=method list

=over

=item *

List branches on a repository

    GET /repos/:user/:repo/branches

Examples:

    my $b = Pithub::Repos::Branches->new;
    my $result = $b->list(
        user => 'plu',
        repo => 'Pithub',
    );

See also L<branch> to get information about a single branch.

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/branches', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method rename

=over

=item *

Rename a branch

    POST /repos/:user/:repo/branches/:branch/rename

Examples:

    my $b = Pithub::Repos::Branches->new;
    my $result = $b->rename(
        user => 'plu',
        repo => 'Pithub',
        branch  => 'travis',
	new_name => 'travis-ci'
    );

See also L<branches> to get a list of all branches.

=back

=cut

sub rename {
    my ( $self, %args ) = @_;
    croak 'Missing parameters: data' unless $args{data};
    croak 'Missing key in parameters: branch' unless $args{data}->{branch};
    croak 'Missing key in parameters: new_name' unless $args{data}->{new_name};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/branches/%s/rename', delete $args{user}, delete $args{repo}, $args{data}->{branch} ),
        %args,
    );
}

=method merge

=over

=item *

Merge a branch

    POST /repos/:user/:repo/merges

Examples:

    my $b = Pithub::Repos::Branches->new;
    my $result = $b->rename(
        user => 'plu',
        repo => 'Pithub',
        base  => 'master',
	head => 'travis',
        message => 'My commit message'
    );

See also L<branches> to get a list of all branches.

=back

=cut

sub merge {
    my ( $self, %args ) = @_;
    croak 'Missing parameters: data' unless $args{data};
    croak 'Missing key in parameters: base' unless $args{data}->{base};
    croak 'Missing key in parameters: head' unless $args{data}->{head};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/merges', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

1;
