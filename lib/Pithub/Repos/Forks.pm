package Pithub::Repos::Forks;

# ABSTRACT: Github v3 Repo Forks API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a fork for the authenicated user.

    POST /repos/:user/:repo/forks

=back

Examples:

    $result = $p->repos->forks->create(
        user => 'plu',
        repo => 'Pithub',
    );

    $result = $p->repos->forks->create(
        user => 'plu',
        repo => 'Pithub',
        org  => 'CPAN-API',
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $org = $args{org} ) {
        return $self->request( POST => sprintf( '/repos/%s/%s/forks', $args{user}, $args{repo} ), { org => $org } );
    }
    return $self->request( POST => sprintf( '/repos/%s/%s/forks', $args{user}, $args{repo} ) );
}

=method list

=over

=item *

List forks

    GET /repos/:user/:repo/forks

=back

Examples:

    $result = $p->repos->forks->list(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/forks', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;
