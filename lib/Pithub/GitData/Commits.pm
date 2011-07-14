package Pithub::GitData::Commits;

# ABSTRACT: Github v3 Git Data Commits API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a Commit

    POST /repos/:user/:repo/git/commits

Examples:

    my $c = Pithub::GitData::Commits->new;
    my $result = $c->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            author => {
                date  => '2008-07-09T16:13:30+12:00',
                email => 'schacon@gmail.com',
                name  => 'Scott Chacon',
            },
            message => 'my commit message',
            parents => ['7d1b31e74ee336d15cbd21741bc88a537ed063a0'],
            tree    => '827efc6d56897b048c772eb4087f854f46256132',
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/git/commits', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Commit

    GET /repos/:user/:repo/git/commits/:sha

Examples:

    my $c = Pithub::GitData::Commits->new;
    my $result = $c->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/commits/%s', delete $args{user}, delete $args{repo}, delete $args{sha} ),
        %args,
    );
}

__PACKAGE__->meta->make_immutable;

1;
