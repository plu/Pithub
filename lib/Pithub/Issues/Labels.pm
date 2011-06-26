package Pithub::Issues::Labels;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Issues::Labels

=head1 METHODS

=head2 add

=over

=item *

Add labels to an issue

    POST /repos/:user/:repo/issues/:id/labels

=back

Examples:

    $result = $p->issues->labels->add(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => ['Label1', 'Label2'],
    );

=cut

sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues/%d/labels', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}

=head2 create

=over

=item *

Create a label

    POST /repos/:user/:repo/labels

=back

Examples:

    $result = $p->issues->labels->create(
        repo => 'Pithub',
        user => 'plu',
        data => {
            color => 'FFFFFF',
            name  => 'some label',
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/labels', $args{user}, $args{repo} ), $args{data} );
}

=head2 delete

=over

=item *

Delete a label

    DELETE /repos/:user/:repo/labels/:id

=back

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        label_id => 1,
    );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label_id' unless $args{label_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/labels/%d', $args{user}, $args{repo}, $args{label_id} ) );
}

=head2 get

=over

=item *

Get a single label

    GET /repos/:user/:repo/labels/:id

=back

Examples:

    $result = $p->issues->labels->get(
        repo => 'Pithub',
        user => 'plu',
        label_id => 1,
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label_id' unless $args{label_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/labels/%d', $args{user}, $args{repo}, $args{label_id} ) );
}

=head2 list

=over

=item *

List all labels for this repository

    GET /repos/:user/:repo/labels

Examples:

    $result = $p->issues->labels->list(
        repo => 'Pithub',
        user => 'plu'
    );

=item *

List labels on an issue

    GET /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=item *

Get labels for every issue in a milestone

    GET /repos/:user/:repo/milestones/:id/labels

Examples:

    $result = $p->issues->labels->get(
        repo         => 'Pithub',
        user         => 'plu',
        milestone_id => 1
    );

=back

=cut

sub list {
}

=head2 remove

=over

=item *

Remove a label from an issue

    DELETE /repos/:user/:repo/issues/:id/labels/:id

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        label_id => 1,
    );

=item *

Remove all labels from an issue

    DELETE /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=back

=cut

sub remove {
}

=head2 replace

=over

=item *

Replace all labels for an issue

    PUT /repos/:user/:repo/issues/:id/labels

=back

Examples:

    my $result = $p->issues->labels->replace( repo => 'Pithub', user => 'plu', issue_id => 1, data => { labels => [qw(label1 label2)] } );

=cut

sub replace {
}

=head2 update

=over

=item *

Update a label

    PATCH /repos/:user/:repo/labels/:id

=back

Examples:

    my $result = $p->issues->labels->update( repo => 'Pithub', user => 'plu', label_id => 1, data => { name => 'other label' } );

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
