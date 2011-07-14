package Pithub::GitData::References;

# ABSTRACT: Github v3 Git Data References API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a Reference

    POST /repos/:user/:repo/git/refs

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            ref => 'refs/heads/master',
            sha => '827efc6d56897b048c772eb4087f854f46256132' .
        }
    );

=back

Parameters in C<< data >> hashref:

=over

=item *

B<ref>: String of the name of the fully qualified reference (ie:
refs/heads/master). If it doesn’t start with 'refs' and have at
least two slashes, it will be rejected.

=item *

B<sha>: String of the SHA1 value to set this reference to

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/git/refs', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Reference

    GET /repos/:user/:repo/git/refs/:ref

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->get(
        user => 'plu',
        repo => 'Pithub',
        ref  => 'heads/master'
    );

=back

The key B<ref> must be formatted as C<< heads/branch >>, not just
C<< branch >>. For example, the call to get the data for a branch
named C<< sc/featureA > would be: C<< heads/sc/featureA >>

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: ref' unless $args{ref};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/refs/%s', delete $args{user}, delete $args{repo}, delete $args{ref} ),
        %args,
    );
}

=method list

=over

=item *

Get all References

    GET /repos/:user/:repo/git/refs

This will return an array of all the references on the system,
including things like notes and stashes if they exist on the server.
Anything in the namespace, not just heads and tags, though that
would be the most common.

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->list(
        user => 'plu',
        repo => 'Pithub',
    );

=item *

You can also request a sub-namespace. For example, to get all the
tag references, you can call:

    GET /repos/:user/:repo/git/refs/tags

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->list(
        user => 'plu',
        repo => 'Pithub',
        ref  => 'tags',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $ref = $args{ref} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/repos/%s/%s/git/refs/%s', delete $args{user}, delete $args{repo}, delete $args{ref} ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/refs', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method update

=over

=item *

Update a Reference

    PATCH /repos/:user/:repo/git/refs/:ref

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->update(
        user => 'plu',
        repo => 'Pithub',
        ref  => 'tags/v1.0',
        data => {
            force => 1,
            sha   => 'aa218f56b14c9653891f9e74264a383fa43fefbd',
        }
    );

=back

Parameters in C<< data >> hashref:

=over

=item *

B<sha>: String of the SHA1 value to set this reference to

=item *

B<force>: Boolean indicating whether to force the update or to make
sure the update is a fast-forward update. The default is false, so
leaving this out or setting it to false will make sure you’re not
overwriting work.

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: ref' unless $args{ref};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/git/refs/%s', delete $args{user}, delete $args{repo}, delete $args{ref} ),
        %args,
    );
}

__PACKAGE__->meta->make_immutable;

1;
