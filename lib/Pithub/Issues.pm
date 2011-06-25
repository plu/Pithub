package Pithub::Issues;

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Events' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Labels' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Milestones' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub::Issues

=head1 METHODS

=head2 create

=over

=item *

Create an issue

    POST /repos/:user/:repo/issues

=back

Examples:

    my $result = $p->issues->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            assignee  => 'octocat',
            body      => "I'm having a problem with this.",
            labels    => [ 'Label1', 'Label2' ],
            milestone => 1,
            title     => 'Found a bug'
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues', $args{user}, $args{repo} ), $args{data} );
}

=head2 get

=over

=item *

Get a single issue

    GET /repos/:user/:repo/issues/:id

=back

Examples:

    my $result = $p->issues->get(
        user => 'plu',
        repo => 'Pithub',
        issue_id => 1,
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issues_id' unless $args{issues_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/%d', $args{user}, $args{repo}, $args{issues_id} ) );
}

=head2 list

=over

=item *

List issues for a repository

    GET /repos/:user/:repo/issues

=back

Examples:

    my $result = $p->issues->list( user => 'plu', repo => 'Pithub' );

=cut

sub list {
}

=head2 update

=over

=item *

Edit an issue

    PATCH /repos/:user/:repo/issues/:id

=back

Examples:

    my $result = $p->issues->update( user => 'plu', repo => 'Pithub', issue_id => 1, { title => 'bug bar foo' } );

=cut

sub update {
}

__PACKAGE__->meta->make_immutable;

1;
