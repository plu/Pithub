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


1;
