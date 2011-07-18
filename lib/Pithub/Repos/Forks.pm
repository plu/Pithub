package Pithub::Repos::Forks;

# ABSTRACT: Github v3 Repo Forks API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Create a fork for the authenicated user.

    POST /repos/:user/:repo/forks

Examples:

    my $f = Pithub::Repos::Forks->new;
    my $result = $f->create(
        user => 'plu',
        repo => 'Pithub',
    );

    # or fork to an org
    my $result = $f->create(
        user => 'plu',
        repo => 'Pithub',
        org  => 'CPAN-API',
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $org = delete $args{org} ) {
        return $self->request(
            method => 'POST',
            path   => sprintf( '/repos/%s/%s/forks', delete $args{user}, delete $args{repo} ),
            data => { org => $org },
            %args,
        );
    }
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/forks', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method list

=over

=item *

List forks

    GET /repos/:user/:repo/forks

Examples:

    my $f = Pithub::Repos::Forks->new;
    my $result = $f->list(
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
        path   => sprintf( '/repos/%s/%s/forks', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

1;
