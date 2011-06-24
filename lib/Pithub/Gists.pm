package Pithub::Gists;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
around qr{^merge_.*?_args$} => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub::Gists

=head1 METHODS

=head2 create

=over

=item *

Create a gist

    POST /gists

=back

Examples:

    my $result = $p->gists->create(
        {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );

=cut

sub create {
    my ( $self, $data ) = @_;
    croak 'Missing parameter: $data (hashref)' unless ref $data eq 'HASH';
    return $self->request( POST => '/gists', $data );
}

=head2 delete

=over

=item *

Delete a gist

    DELETE /gists/:id

=back

Examples:

    $result = $p->gists->delete(784612);

=cut

sub delete {
    my ( $self, $gist_id ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    return $self->request( DELETE => sprintf( '/gists/%d', $gist_id ) );
}

=head2 fork

=over

=item *

Fork a gist

    POST /gists/:id/fork

=back

Examples:

    $result = $p->gists->fork(784612);

=cut

sub fork {
    my ( $self, $gist_id ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    return $self->request( POST => sprintf( '/gists/%d/fork', $gist_id ) );
}

=head2 get

=over

=item *

Get a single gist

    GET /gists/:id

=back

Examples:

    $result = $p->gists->get(784612);

=cut

sub get {
    my ( $self, $gist_id ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    return $self->request( GET => sprintf( '/gists/%d', $gist_id ) );
}

=head2 is_starred

=over

=item *

Check if a gist is starred

    GET /gists/:id/star

=back

Examples:

    $result = $p->gists->is_starred(784612);

=cut

sub is_starred {
    my ( $self, $gist_id ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    return $self->request( GET => sprintf( '/gists/%d/star', $gist_id ) );
}

=head2 list

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

=head2 star

=over

=item *

Star a gist

    PUT /gists/:id/star

=back

Examples:

    $result = $p->gists->star(784612);

=cut

sub star {
    my ( $self, $gist_id ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    return $self->request( PUT => sprintf( '/gists/%d/star', $gist_id ) );
}

=head2 unstar

=over

=item *

Unstar a gist

    DELETE /gists/:id/star

=back

Examples:

    $result = $p->gists->unstar(784612);

=cut

sub unstar {
    my ( $self, $gist_id ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    return $self->request( DELETE => sprintf( '/gists/%d/star', $gist_id ) );
}

=head2 update

=over

=item *

Edit a gist

    PATCH /gists/:id

=back

Examples:

    my $result = $p->gists->update( 784612 => { description => 'bar foo' } );

=cut

sub update {
    my ( $self, $gist_id, $data ) = @_;
    croak 'Missing parameter: $gist_id' unless $gist_id;
    croak 'Missing parameter: $data (hashref)' unless ref $data eq 'HASH';
    return $self->request( PATCH => sprintf( '/gists/%d', $gist_id ), $data );
}

__PACKAGE__->meta->make_immutable;

1;
