package Pithub::Repos::Releases;

# ABSTRACT: Github v3 Repo Releases API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method list

=over

=item *

List releases for a repository.

    GET /repos/:owner/:repo/releases

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->get(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/releases', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a single release.

    GET /repos/:owner/:repo/releases/:id

Examples:

    my $r = Pithub::Repos::Releases->new;
    my $result = $r->get(
        repo       => 'Pithub',
        user       => 'plu',
        release_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: release_id' unless $args{release_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/releases/%d', delete $args{user}, delete $args{repo}, delete $args{release_id} ),
        %args,
    );
}

1;
