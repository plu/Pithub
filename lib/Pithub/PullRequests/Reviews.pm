package Pithub::PullRequests::Reviews;
our $VERSION = '0.01044';

# ABSTRACT: Github v3 Pull Request Reviews API

use Moo;
use Carp qw( croak );
extends 'Pithub::Base';

=head1 DESCRIPTION

See also: L<https://docs.github.com/en/rest/pulls/reviews>

=method create

=over

=item *

Create a review for a pull request. Without an C<event> the review
is created as C<PENDING>, and L</submit> submits it later.

    POST /repos/:user/:repo/pulls/:id/reviews

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->create(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        data            => {
            commit_id => '6dcb09b5b57875f334f61aebed695e2e4193db5e',
            body      => 'Looks good, one nit.',
            event     => 'COMMENT',
            comments  => [
                {
                    path => 'lib/Pithub.pm',
                    line => 4,
                    side => 'RIGHT',
                    body => 'Typo here.',
                },
            ],
        },
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews', delete $args{user},
            delete $args{repo},              delete $args{pull_request_id}
        ),
        %args,
    );
}

=method delete

=over

=item *

Delete a pending review

    DELETE /repos/:user/:repo/pulls/:id/reviews/:review_id

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->delete(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        review_id       => 80,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: review_id' unless $args{review_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews/%s', delete $args{user},
            delete $args{repo},                 delete $args{pull_request_id},
            delete $args{review_id}
        ),
        %args,
    );
}

=method dismiss

=over

=item *

Dismiss a review

    PUT /repos/:user/:repo/pulls/:id/reviews/:review_id/dismissals

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->dismiss(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        review_id       => 80,
        data            => { message => 'Addressed in a later commit.' },
    );

=back

=cut

sub dismiss {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: review_id' unless $args{review_id};
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PUT',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews/%s/dismissals', delete $args{user},
            delete $args{repo}, delete $args{pull_request_id},
            delete $args{review_id}
        ),
        %args,
    );
}

=method get

=over

=item *

Get a single review

    GET /repos/:user/:repo/pulls/:id/reviews/:review_id

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->get(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        review_id       => 80,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: review_id' unless $args{review_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews/%s', delete $args{user},
            delete $args{repo},                 delete $args{pull_request_id},
            delete $args{review_id}
        ),
        %args,
    );
}

=method list

=over

=item *

List reviews on a pull request

    GET /repos/:user/:repo/pulls/:id/reviews

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->list(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews', delete $args{user},
            delete $args{repo},              delete $args{pull_request_id}
        ),
        %args,
    );
}

=method list_comments

=over

=item *

List the comments of a review

    GET /repos/:user/:repo/pulls/:id/reviews/:review_id/comments

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->list_comments(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        review_id       => 80,
    );

=back

=cut

sub list_comments {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: review_id' unless $args{review_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews/%s/comments', delete $args{user},
            delete $args{repo}, delete $args{pull_request_id},
            delete $args{review_id}
        ),
        %args,
    );
}

=method submit

=over

=item *

Submit a pending review

    POST /repos/:user/:repo/pulls/:id/reviews/:review_id/events

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->submit(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        review_id       => 80,
        data            => { event => 'APPROVE', body => 'Ship it.' },
    );

=back

=cut

sub submit {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: review_id' unless $args{review_id};
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews/%s/events', delete $args{user},
            delete $args{repo}, delete $args{pull_request_id},
            delete $args{review_id}
        ),
        %args,
    );
}

=method update

=over

=item *

Update the body of a review

    PUT /repos/:user/:repo/pulls/:id/reviews/:review_id

Examples:

    my $r = Pithub::PullRequests::Reviews->new;
    my $result = $r->update(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        review_id       => 80,
        data            => { body => 'Updated review text' },
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id'
        unless $args{pull_request_id};
    croak 'Missing key in parameters: review_id' unless $args{review_id};
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PUT',
        path   => sprintf(
            '/repos/%s/%s/pulls/%s/reviews/%s', delete $args{user},
            delete $args{repo},                 delete $args{pull_request_id},
            delete $args{review_id}
        ),
        %args,
    );
}

1;
