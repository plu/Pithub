package Pithub::Issues::Events;

# ABSTRACT: Github v3 Issue Events API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method get

=over

=item *

Get a single event

    GET /repos/:user/:repo/issues/events/:id

Examples:

    my $e = Pithub::Issues::Events->new;
    my $result = $e->get(
        repo     => 'Pithub',
        user     => 'plu',
        event_id => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: event_id' unless $args{event_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/issues/events/%s', delete $args{user}, delete $args{repo}, delete $args{event_id} ),
        %args,
    );
}

=method list

=over

=item *

List events for an issue

    GET /repos/:user/:repo/issues/:issue_id/events

Examples:

    my $e = Pithub::Issues::Events->new;
    my $result = $e->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=item *

List events for a repository

    GET /repos/:user/:repo/issues/events

Examples:

    my $e = Pithub::Issues::Events->new;
    my $result = $e->list(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $issue_id = delete $args{issue_id} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/repos/%s/%s/issues/%s/events', delete $args{user}, delete $args{repo}, $issue_id ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/issues/events', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

1;
