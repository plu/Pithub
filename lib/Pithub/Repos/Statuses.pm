package Pithub::Repos::Statuses;

# ABSTRACT:  Github v3 repos / statuses API

use Moo;
use Carp qw(croak);

extends 'Pithub::Base';

=method list

Extra arguments

=over

=item * ref

The SHA, branch, or tag-name to get statuses for

=back

List statuses for a ref

    GET /repos/:user/:repo/statuses/:ref

Examples:

    my $statuses = Pithub::Repos::Statuses->new;
    my $result   = $statuses->list( ref => 'master' );

=cut

sub list {
    my ($self, %args) = @_;

    $self->_validate_user_repo_args( \%args );
    my $req = {
        method => 'GET',
        path => sprintf(
            '/repos/%s/%s/statuses/%s',
            delete $args{user}, delete $args{repo}, delete $args{ref}
        ),
        %args
    };
    return $self->request(%$req);
}

=method create

Extra arguments

=over

=item state (required)

The state of the status. Can be one of 'pending', 'success', 'error' or 'failure'.

=item target_url

This URL will be used to link from the status to some related page, for instance
the build result for this specific SHA.

=item description

A short description of the status

=back

Add a status to a SHA.

    POST /repos/:user/:repo/statuses/:sha

Examples:

    my $statuses = Pithub::Repos::Statuses->new;
    my $result   = $statuses->create( user => 'plu', repo => 'Pithub',
        sha => '0123456', 
        data => {
            status => 'error',
            description => 'Build failed',
            target_url => 'https://travis-ci.org/some/url/0123456',
        },
    );

=cut

sub create {
    my ($self, %args) = @_;
    $self->_validate_user_repo_args( \%args );
    croak 'Missing state paramenter. Must be one of pending, success, error or failure'
        unless $args{data}->{state};

    unless ($args{data}->{state} =~ m/^(?:pending|success|error|failure)$/) {
        croak 'state param must be one of pending, success, error, failure. Was ' .
        $args{data}->{state};
    }

    my $req = {
        method => 'POST',
        path => sprintf(
            '/repos/%s/%s/statuses/%s',
            delete $args{user}, delete $args{repo}, delete $args{sha},
        ),
        %args
    };

    return $self->request(%$req);
}


1;
