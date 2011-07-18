package Pithub::PullRequests::Comments;

# ABSTRACT: Github v3 Pull Request Comments API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Create a comment

    POST /repos/:user/:repo/pulls/:id/comments

Examples:

    my $c = Pithub::PullRequests::Comments->new;
    my $result = $c->create(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        data            => {
            body      => 'Nice change',
            commit_id => '6dcb09b5b57875f334f61aebed695e2e4193db5e',
            path      => 'file1.txt',
            position  => 4,
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/pulls/%s/comments', delete $args{user}, delete $args{repo}, delete $args{pull_request_id} ),
        %args
    );
}

=method delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/pulls/comments/:id

Examples:

    my $c = Pithub::PullRequests::Comments->new;
    my $result = $c->delete(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/pulls/comments/%s', delete $args{user}, delete $args{repo}, delete $args{comment_id} ),
        %args,
    );
}

=method get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/pulls/comments/:id

Examples:

    my $c = Pithub::PullRequests::Comments->new;
    my $result = $c->get(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/pulls/comments/%s', delete $args{user}, delete $args{repo}, delete $args{comment_id} ),
        %args,
    );
}

=method list

=over

=item *

List comments on a pull request

    GET /repos/:user/:repo/pulls/:id/comments

Examples:

    my $c = Pithub::PullRequests::Comments->new;
    my $result = $c->list(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/pulls/%s/comments', delete $args{user}, delete $args{repo}, delete $args{pull_request_id} ),
        %args,
    );
}

=method update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/pulls/comments/:id

Examples:

    my $c = Pithub::PullRequests::Comments->new;
    my $result = $c->update(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
        data       => { body => 'some updated comment' },
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/pulls/comments/%s', delete $args{user}, delete $args{repo}, delete $args{comment_id} ),
        %args,
    );
}

1;
