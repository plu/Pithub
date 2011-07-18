package Pithub::Repos::Keys;

# ABSTRACT: Github v3 Repo Keys API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Create

    POST /repos/:user/:repo/keys

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            title => 'some key',
            key   => 'ssh-rsa AAA...',
        },
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/keys', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method delete

=over

=item *

Delete

    DELETE /repos/:user/:repo/keys/:id

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->delete(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/keys/%s', delete $args{user}, delete $args{repo}, delete $args{key_id} ),
        %args,
    );
}

=method get

=over

=item *

Get

    GET /repos/:user/:repo/keys/:id

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->get(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/keys/%s', delete $args{user}, delete $args{repo}, delete $args{key_id} ),
        %args,
    );
}

=method list

=over

=item *

List

    GET /repos/:user/:repo/keys

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->list(
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
        path   => sprintf( '/repos/%s/%s/keys', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method update

=over

=item *

Edit

    PATCH /repos/:user/:repo/keys/:id

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->update(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
        data   => { title => 'some new title' },
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/keys/%s', delete $args{user}, delete $args{repo}, delete $args{key_id} ),
        %args,
    );
}

1;
