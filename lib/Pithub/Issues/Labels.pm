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

Add a label to an issue

=item *

Add labels to an issue

    POST /repos/:user/:repo/issues/:id/labels

=back

Examples:

    $result = $p->issues->labels->create(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => { name => 'some label' }
    );

=cut

sub add {
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
        data => { name => 'some label' }
    );

=cut

sub create {
}

=head2 delete

=over

=item *

Delete a label

    DELETE /repos/:user/:repo/labels/:id

=back

=item *

Remove a label from an issue

    DELETE /repos/:user/:repo/issues/:id/labels/:id

=item *

Remove all labels from an issue

    DELETE /repos/:user/:repo/issues/:id/labels

=back

Examples:

    my $result = $p->issues->labels->delete( repo => 'Pithub', user => 'plu', label_id => 1 );
    my $result = $p->issues->labels->delete( repo => 'Pithub', user => 'plu', issue_id => 1 );
    my $result = $p->issues->labels->delete( repo => 'Pithub', user => 'plu', issue_id => 1, label_id => 1 );

=cut

sub delete {
}

=head2 get

=over

=item *

Get a single label

    GET /repos/:user/:repo/labels/:id

=item *

Get labels for every issue in a milestone

    GET /repos/:user/:repo/milestones/:id/labels

=back

Examples:

    my $result = $p->issues->labels->get( repo => 'Pithub', user => 'plu', label_id => 1 );
    my $result = $p->issues->labels->get( repo => 'Pithub', user => 'plu', milestone_id => 1 );

=cut

sub get {
}

=head2 list

=over

=item *

List all labels for this repository

    GET /repos/:user/:repo/labels

=item *

List labels on an issue

    GET /repos/:user/:repo/issues/:id/labels

=back

Examples:

    my $result = $p->issues->labels->list( repo => 'Pithub', user => 'plu' );
    my $result = $p->issues->labels->list( repo => 'Pithub', user => 'plu', issue_id => 1 );

=cut

sub list {
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
