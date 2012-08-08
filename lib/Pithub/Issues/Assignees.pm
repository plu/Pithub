package Pithub::Issues::Assignees;

# ABSTRACT: Github v3 Issue Assignees API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method check

=over

=item *

You may also check to see if a particular user is an assignee for a repository.

    GET /repos/:user/:repo/assignees/:assignee

If the given assignee login belongs to an assignee for the repository, a 204
header with no content is returned.

Examples:

    my $c      = Pithub::Issues::Assignees->new;
    my $result = $c->check(
        repo     => 'Pithub',
        user     => 'plu',
        assignee => 'plu',
    );
    if ( $result->success ) {
        print "plu is an assignee for the repo plu/Pithub.git";
    }

=back

=cut

sub check {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: assignee' unless $args{assignee};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/assignees/%s', delete $args{user}, delete $args{repo}, delete $args{assignee} ),
        %args,
    );
}

=method list

=over

=item *

This call lists all the available assignees (owner + collaborators)
to which issues may be assigned.

    GET /repos/:user/:repo/assignees

Examples:

    my $c      = Pithub::Issues::Assignees->new;
    my $result = $c->list(
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
        path   => sprintf( '/repos/%s/%s/assignees', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

1;
