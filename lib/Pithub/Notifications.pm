package Pithub::Notifications;

# ABSTRACT: Github v3 Notifications API

use Moo;

our $VERSION = '0.01044';

use Carp qw( croak );

extends 'Pithub::Base';

=head1 DESCRIPTION

All calls of the notifications API need a L<token|Pithub::Base/token>.

See also: L<https://docs.github.com/en/rest/activity/notifications>

=method delete_thread_subscription

=over

=item *

Delete a thread subscription. Notifications for the thread can come
back, for example when the user is mentioned again.

    DELETE /notifications/threads/:thread_id/subscription

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->delete_thread_subscription( thread_id => 1 );

=back

=cut

sub delete_thread_subscription {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: thread_id' unless $args{thread_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf(
            '/notifications/threads/%s/subscription',
            delete $args{thread_id}
        ),
        %args,
    );
}

=method get

=over

=item *

Get a thread

    GET /notifications/threads/:thread_id

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->get( thread_id => 1 );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: thread_id' unless $args{thread_id};
    return $self->request(
        method => 'GET',
        path   =>
            sprintf( '/notifications/threads/%s', delete $args{thread_id} ),
        %args,
    );
}

=method get_thread_subscription

=over

=item *

Get the subscription of the authenticated user to a thread

    GET /notifications/threads/:thread_id/subscription

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->get_thread_subscription( thread_id => 1 );

=back

=cut

sub get_thread_subscription {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: thread_id' unless $args{thread_id};
    return $self->request(
        method => 'GET',
        path   => sprintf(
            '/notifications/threads/%s/subscription',
            delete $args{thread_id}
        ),
        %args,
    );
}

=method list

=over

=item *

List notifications for the authenticated user

    GET /notifications

=item *

List repository notifications for the authenticated user

    GET /repos/:user/:repo/notifications

This call is made when B<user> and B<repo> are given, as parameters
or as L<attributes|Pithub::Base/ATTRIBUTES> of the object.

=back

This API call can be influenced via the C<< params >> hashref with
following parameters:

=over

=item *

B<all>: C<< true >> to show notifications marked as read too.
Default: C<< false >>

=item *

B<participating>: C<< true >> to show only the notifications in
which the user is directly participating or mentioned. Default:
C<< false >>

=item *

B<since>: optional string of a timestamp in ISO 8601 format:
YYYY-MM-DDTHH:MM:SSZ. Only notifications updated after this time
are returned.

=item *

B<before>: optional string of a timestamp in ISO 8601 format:
YYYY-MM-DDTHH:MM:SSZ. Only notifications updated before this time
are returned.

=item *

B<per_page> and B<page>: see L<Pithub::Base/per_page>. Pithub sends
a C<< per_page >> of 100 by default, but Github documents a maximum of
50 for C<< GET /notifications >>.

=back

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->list(
        params => {
            all   => 'true',
            since => '2026-01-01T00:00:00Z',
        },
    );

    my $result = $n->list(
        user => 'plu',
        repo => 'Pithub',
    );

Github optimizes this call for polling. Send the C<< Last-Modified >>
header of the previous response as C<< If-Modified-Since >> with the
C<< headers >> hashref of L<Pithub::Base/request>, and read the response
headers from L<Pithub::Result/response>. The C<< X-Poll-Interval >>
header gives the number of seconds to wait before the next poll.

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->list;
    my $last_modified = $result->response->header('Last-Modified');
    sleep $result->response->header('X-Poll-Interval');

    $result = $n->list(
        headers => { 'If-Modified-Since' => $last_modified },
    );

When nothing changed, Github answers C<< 304 Not Modified >>. Pithub
keeps an in-memory cache of responses by URL and sends
C<< If-None-Match >> for a URL that is in it. When Github answers 304 to
such a request, you get the cached response again, with its status
code. So compare C<< Last-Modified >> instead of testing only for a
C<< code >> of 304.

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_get_user_repo_args( \%args );
    if ( $args{user} && $args{repo} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf(
                '/repos/%s/%s/notifications', delete $args{user},
                delete $args{repo}
            ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => '/notifications',
        %args,
    );
}

=method mark_as_read

=over

=item *

Mark notifications as read

    PUT /notifications

=item *

Mark repository notifications as read

    PUT /repos/:user/:repo/notifications

This call is made when B<user> and B<repo> are given, as parameters
or as L<attributes|Pithub::Base/ATTRIBUTES> of the object.

=back

The optional C<< data >> hashref can contain B<last_read_at>, a
timestamp in ISO 8601 format. Notifications updated after this time
are not marked as read. Default: the current time.

Github answers C<< 205 Reset Content >>, or C<< 202 Accepted >> when there
are too many notifications to mark as read at once.

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->mark_as_read(
        data => { last_read_at => '2026-01-01T00:00:00Z' },
    );

    my $result = $n->mark_as_read(
        user => 'plu',
        repo => 'Pithub',
    );

=cut

sub mark_as_read {
    my ( $self, %args ) = @_;
    $self->_get_user_repo_args( \%args );
    if ( $args{user} && $args{repo} ) {
        return $self->request(
            method => 'PUT',
            path   => sprintf(
                '/repos/%s/%s/notifications', delete $args{user},
                delete $args{repo}
            ),
            %args,
        );
    }
    return $self->request(
        method => 'PUT',
        path   => '/notifications',
        %args,
    );
}

=method mark_thread_as_done

=over

=item *

Mark a thread as done

    DELETE /notifications/threads/:thread_id

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->mark_thread_as_done( thread_id => 1 );

=back

=cut

sub mark_thread_as_done {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: thread_id' unless $args{thread_id};
    return $self->request(
        method => 'DELETE',
        path   =>
            sprintf( '/notifications/threads/%s', delete $args{thread_id} ),
        %args,
    );
}

=method mark_thread_as_read

=over

=item *

Mark a thread as read

    PATCH /notifications/threads/:thread_id

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->mark_thread_as_read( thread_id => 1 );

=back

=cut

sub mark_thread_as_read {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: thread_id' unless $args{thread_id};
    return $self->request(
        method => 'PATCH',
        path   =>
            sprintf( '/notifications/threads/%s', delete $args{thread_id} ),
        %args,
    );
}

=method set_thread_subscription

=over

=item *

Set a thread subscription. Use this to ignore future notifications
for a thread, or to subscribe to a thread again.

    PUT /notifications/threads/:thread_id/subscription

The optional C<< data >> hashref can contain B<ignored>, a boolean.
C<< true >> blocks all notifications from the thread. Default:
C<< false >>

Examples:

    my $n      = Pithub::Notifications->new( token => 'b3c62c6' );
    my $result = $n->set_thread_subscription(
        thread_id => 1,
        data      => { ignored => JSON::MaybeXS::true() },
    );

=back

=cut

sub set_thread_subscription {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: thread_id' unless $args{thread_id};
    return $self->request(
        method => 'PUT',
        path   => sprintf(
            '/notifications/threads/%s/subscription',
            delete $args{thread_id}
        ),
        %args,
    );
}

1;
