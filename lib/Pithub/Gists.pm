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

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->create(
        data => {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );
    if ( $result->success ) {
        printf "The new gist is available at %s\n", $result->content->{html_url};
    }

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'POST',
        path   => '/gists',
        %args,
    );
}

=method delete

=over

=item *

Delete a gist

    DELETE /gists/:id

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->delete( gist_id => 784612 );
    if ( $result->success ) {
        print "The gist 784612 has been deleted\n";
    }

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/gists/%s', delete $args{gist_id} ),
        %args,
    );
}

=method fork

=over

=item *

Fork a gist

    POST /gists/:id/fork

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->fork( gist_id => 784612 );
    if ( $result->success ) {
        printf "The gist 784612 has been forked: %s\n", $result->content->{html_url};
    }

=back

=cut

sub fork {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'POST',
        path   => sprintf( '/gists/%s/fork', delete $args{gist_id} ),
        %args,
    );
}

=method get

=over

=item *

Get a single gist

    GET /gists/:id

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->get( gist_id => 784612 );
    if ( $result->success ) {
        print $result->content->{html_url};
    }

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/gists/%s', delete $args{gist_id} ),
        %args,
    );
}

=method is_starred

=over

=item *

Check if a gist is starred

    GET /gists/:id/star

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->is_starred( gist_id => 784612 );

=back

=cut

sub is_starred {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/gists/%s/star', delete $args{gist_id} ),
        %args,
    );
}

=method list

=over

=item *

List a user’s gists:

    GET /users/:user/gists

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list( user => 'miyagawa' );
    if ( $result->success ) {
        while ( my $row = $result->next ) {
            printf "%s => %s\n", $row->{html_url}, $row->{description} || 'no description';
        }
    }

=item *

List the authenticated user’s gists or if called anonymously,
this will returns all public gists:

    GET /gists

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list;

=item *

List all public gists:

    GET /gists/public

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list( public => 1 );

=item *

List the authenticated user’s starred gists:

    GET /gists/starred

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list( starred => 1 );

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = delete $args{user} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/users/%s/gists', $user ),
            %args,
        );
    }
    elsif ( delete $args{starred} ) {
        return $self->request(
            method => 'GET',
            path   => '/gists/starred',
            %args,
        );
    }
    elsif ( delete $args{public} ) {
        return $self->request(
            method => 'GET',
            path   => '/gists/public',
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => '/gists',
        %args,
    );
}

=method star

=over

=item *

Star a gist

    PUT /gists/:id/star

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->star( gist_id => 784612 );

=back

=cut

sub star {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/gists/%s/star', delete $args{gist_id} ),
        %args,
    );
}

=method unstar

=over

=item *

Unstar a gist

    DELETE /gists/:id/star

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->unstar( gist_id => 784612 );

=back

=cut

sub unstar {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/gists/%s/star', delete $args{gist_id} ),
        %args,
    );
}

=method update

=over

=item *

Edit a gist

    PATCH /gists/:id

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->update(
        gist_id => 784612,
        data    => { description => 'bar foo' }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/gists/%s', delete $args{gist_id} ),
        %args,
    );
}

__PACKAGE__->meta->make_immutable;

1;
