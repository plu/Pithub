package Pithub::Repos::Actions::Workflows;

# ABSTRACT: Github v3 Repo Actions Workflows API

use Moo;

our $VERSION = '0.01042';

use Carp qw( croak );
extends 'Pithub::Base';

=head1 DESCRIPTION

This class is incomplete. It's currently missing support for C<dispatches>,
C<enable> and C<timing>. Please send patches for any additional functionality
you may require.

=method get

=over

=item *

Get a single workflow.

    GET /repos/:owner/:repo/actions/workflows/:id

Examples:

    my $a      = Pithub::Repos::Actions::Workflows->new;
    my $result = $a->get(
        repo        => 'graylog2-server',
        user        => 'Graylog2',
        workflow_id => 81148,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    my $param_name = 'workflow_id';
    my $id         = delete $args{$param_name};
    croak 'Missing key in parameters: ' . $param_name unless $id;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/actions/workflows/%s', delete $args{user},
            delete $args{repo},                  $id,
        ),
        %args,
    );
}

=method list

=over

=item *

List workflows for a repo.

    GET /repos/:owner/:repo/actions/workflows

Examples:

    my $a = Pithub::Repos::Actions::Workflows->new;
    my $result = $a->list(
        repo       => 'graylog2-server',
        user       => 'Graylog2',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/actions/workflows', delete $args{user},
            delete $args{repo}
        ),
        %args,
    );
}

1;
