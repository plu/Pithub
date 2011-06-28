package Pithub::Gists;

# ABSTRACT: Github v3 Gists API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
around qr{^merge_.*?_args$} => \&Pithub::Base::_merge_args;

=method create

=over

=item *

Create a gist

    POST /gists

=back

Examples:

    $result = $p->gists->create(
        data => {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => '/gists', $args{data} );
}

=method delete

=over

=item *

Delete a gist

    DELETE /gists/:id

=back

Examples:

    $result = $p->gists->delete( gist_id => 784612 );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( DELETE => sprintf( '/gists/%d', $args{gist_id} ) );
}

=method fork

=over

=item *

Fork a gist

    POST /gists/:id/fork

=back

Examples:

    $result = $p->gists->fork( gist_id => 784612 );

=cut

sub fork {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( POST => sprintf( '/gists/%d/fork', $args{gist_id} ) );
}

=method get

=over

=item *

Get a single gist

    GET /gists/:id

=back

Examples:

    $result = $p->gists->get( gist_id => 784612 );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( GET => sprintf( '/gists/%d', $args{gist_id} ) );
}

=method is_starred

=over

=item *

Check if a gist is starred

    GET /gists/:id/star

=back

Examples:

    $result = $p->gists->is_starred( gist_id => 784612 );

=cut

sub is_starred {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( GET => sprintf( '/gists/%d/star', $args{gist_id} ) );
}

=method list

=over

=item *

List a user’s gists:

    GET /users/:user/gists

=item *

List the authenticated user’s gists or if called anonymously,
this will returns all public gists:

    GET /gists

=item *

List all public gists:

    GET /gists/public

=item *

List the authenticated user’s starred gists:

    GET /gists/starred

=back

Examples:

    # List a user’s gists:
    $result = $p->gists->list( user => 'plu' );

    # List the authenticated user’s gists or if called anonymously,
    # this will returns all public gists:
    $result = $p->gists->list;

    # List the authenticated user’s starred gists:
    $result = $p->gists->list( starred => 1 );

    # List all public gists:
    $result = $p->gists->list( public => 1 );

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/gists', $user ) );
    }
    elsif ( $args{starred} ) {
        return $self->request( GET => '/gists/starred' );
    }
    elsif ( $args{public} ) {
        return $self->request( GET => '/gists/public' );
    }
    return $self->request( GET => '/gists' );
}

=method star

=over

=item *

Star a gist

    PUT /gists/:id/star

=back

Examples:

    $result = $p->gists->star( gist_id => 784612 );

=cut

sub star {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( PUT => sprintf( '/gists/%d/star', $args{gist_id} ) );
}

=method unstar

=over

=item *

Unstar a gist

    DELETE /gists/:id/star

=back

Examples:

    $result = $p->gists->unstar( gist_id => 784612 );

=cut

sub unstar {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( DELETE => sprintf( '/gists/%d/star', $args{gist_id} ) );
}

=method update

=over

=item *

Edit a gist

    PATCH /gists/:id

=back

Examples:

    $result = $p->gists->update(
        gist_id => 784612,
        data    => { description => 'bar foo' }
    );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/gists/%d', $args{gist_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
