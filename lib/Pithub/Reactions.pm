package Pithub::Reactions;

# ABSTRACT: Github v3 Reactions API

use Moo;

our $VERSION = '0.01044';

use Carp qw( croak );

extends 'Pithub::Base';

=head1 DESCRIPTION

Reactions are emoji responses to issues, comments and releases. See
L<https://docs.github.com/en/rest/reactions/reactions>.

Every C<list_*> method accepts a C<params> hashref with the optional
keys C<content> (return only reactions of this type), C<per_page>
and C<page>.

Every C<create_*> method takes a C<data> hashref with the key
C<content>, which must be one of C<+1>, C<-1>, C<laugh>, C<confused>,
C<heart>, C<hooray>, C<rocket> or C<eyes>. Any other value croaks
before a request is sent.

Every C<create_*> and C<delete_*> method requires a token.

This class does not cover reactions to team discussions, which Github
is retiring.

=cut

my @CONTENT = qw( +1 -1 laugh confused heart hooray rocket eyes );
my %CONTENT = map { $_ => 1 } @CONTENT;

=method create_for_commit_comment

=over

=item *

Create a reaction for a commit comment

    POST /repos/:user/:repo/comments/:comment_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->create_for_commit_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
        data       => { content => 'heart' },
    );

=back

=cut

sub create_for_commit_comment {
    my ( $self, %args ) = @_;
    return $self->_create( 'comments', 'comment_id', \%args );
}

=method create_for_issue

=over

=item *

Create a reaction for an issue

    POST /repos/:user/:repo/issues/:issue_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->create_for_issue(
        user     => 'plu',
        repo     => 'Pithub',
        issue_id => 1,
        data     => { content => '+1' },
    );

=back

=cut

sub create_for_issue {
    my ( $self, %args ) = @_;
    return $self->_create( 'issues', 'issue_id', \%args );
}

=method create_for_issue_comment

=over

=item *

Create a reaction for an issue comment

    POST /repos/:user/:repo/issues/comments/:comment_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->create_for_issue_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
        data       => { content => 'laugh' },
    );

=back

=cut

sub create_for_issue_comment {
    my ( $self, %args ) = @_;
    return $self->_create( 'issues/comments', 'comment_id', \%args );
}

=method create_for_pull_request_comment

=over

=item *

Create a reaction for a pull request review comment

    POST /repos/:user/:repo/pulls/comments/:comment_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->create_for_pull_request_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
        data       => { content => 'rocket' },
    );

=back

=cut

sub create_for_pull_request_comment {
    my ( $self, %args ) = @_;
    return $self->_create( 'pulls/comments', 'comment_id', \%args );
}

=method create_for_release

=over

=item *

Create a reaction for a release

    POST /repos/:user/:repo/releases/:release_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->create_for_release(
        user       => 'plu',
        repo       => 'Pithub',
        release_id => 1,
        data       => { content => 'hooray' },
    );

=back

=cut

sub create_for_release {
    my ( $self, %args ) = @_;
    return $self->_create( 'releases', 'release_id', \%args );
}

=method delete_for_commit_comment

=over

=item *

Delete a reaction to a commit comment

    DELETE /repos/:user/:repo/comments/:comment_id/reactions/:reaction_id

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->delete_for_commit_comment(
        user        => 'plu',
        repo        => 'Pithub',
        comment_id  => 1,
        reaction_id => 2,
    );

=back

=cut

sub delete_for_commit_comment {
    my ( $self, %args ) = @_;
    return $self->_delete( 'comments', 'comment_id', \%args );
}

=method delete_for_issue

=over

=item *

Delete a reaction to an issue

    DELETE /repos/:user/:repo/issues/:issue_id/reactions/:reaction_id

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->delete_for_issue(
        user        => 'plu',
        repo        => 'Pithub',
        issue_id    => 1,
        reaction_id => 2,
    );

=back

=cut

sub delete_for_issue {
    my ( $self, %args ) = @_;
    return $self->_delete( 'issues', 'issue_id', \%args );
}

=method delete_for_issue_comment

=over

=item *

Delete a reaction to an issue comment

    DELETE /repos/:user/:repo/issues/comments/:comment_id/reactions/:reaction_id

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->delete_for_issue_comment(
        user        => 'plu',
        repo        => 'Pithub',
        comment_id  => 1,
        reaction_id => 2,
    );

=back

=cut

sub delete_for_issue_comment {
    my ( $self, %args ) = @_;
    return $self->_delete( 'issues/comments', 'comment_id', \%args );
}

=method delete_for_pull_request_comment

=over

=item *

Delete a reaction to a pull request review comment

    DELETE /repos/:user/:repo/pulls/comments/:comment_id/reactions/:reaction_id

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->delete_for_pull_request_comment(
        user        => 'plu',
        repo        => 'Pithub',
        comment_id  => 1,
        reaction_id => 2,
    );

=back

=cut

sub delete_for_pull_request_comment {
    my ( $self, %args ) = @_;
    return $self->_delete( 'pulls/comments', 'comment_id', \%args );
}

=method delete_for_release

=over

=item *

Delete a reaction to a release

    DELETE /repos/:user/:repo/releases/:release_id/reactions/:reaction_id

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->delete_for_release(
        user        => 'plu',
        repo        => 'Pithub',
        release_id  => 1,
        reaction_id => 2,
    );

=back

=cut

sub delete_for_release {
    my ( $self, %args ) = @_;
    return $self->_delete( 'releases', 'release_id', \%args );
}

=method list_for_commit_comment

=over

=item *

List reactions for a commit comment

    GET /repos/:user/:repo/comments/:comment_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->list_for_commit_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=back

=cut

sub list_for_commit_comment {
    my ( $self, %args ) = @_;
    return $self->_list( 'comments', 'comment_id', \%args );
}

=method list_for_issue

=over

=item *

List reactions for an issue

    GET /repos/:user/:repo/issues/:issue_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->list_for_issue(
        user     => 'plu',
        repo     => 'Pithub',
        issue_id => 1,
        params   => { content => '+1', per_page => 100 },
    );

=back

=cut

sub list_for_issue {
    my ( $self, %args ) = @_;
    return $self->_list( 'issues', 'issue_id', \%args );
}

=method list_for_issue_comment

=over

=item *

List reactions for an issue comment

    GET /repos/:user/:repo/issues/comments/:comment_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->list_for_issue_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=back

=cut

sub list_for_issue_comment {
    my ( $self, %args ) = @_;
    return $self->_list( 'issues/comments', 'comment_id', \%args );
}

=method list_for_pull_request_comment

=over

=item *

List reactions for a pull request review comment

    GET /repos/:user/:repo/pulls/comments/:comment_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->list_for_pull_request_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=back

=cut

sub list_for_pull_request_comment {
    my ( $self, %args ) = @_;
    return $self->_list( 'pulls/comments', 'comment_id', \%args );
}

=method list_for_release

=over

=item *

List reactions for a release

    GET /repos/:user/:repo/releases/:release_id/reactions

Examples:

    my $r      = Pithub::Reactions->new;
    my $result = $r->list_for_release(
        user       => 'plu',
        repo       => 'Pithub',
        release_id => 1,
    );

=back

=cut

sub list_for_release {
    my ( $self, %args ) = @_;
    return $self->_list( 'releases', 'release_id', \%args );
}

# $prefix is the path segment between /repos/:user/:repo/ and the id of
# the reacted-to object, $id_key the name of the argument holding that id.
sub _path {
    my ( $self, $prefix, $id_key, $args ) = @_;
    croak "Missing key in parameters: $id_key" unless $args->{$id_key};
    $self->_validate_user_repo_args($args);
    return sprintf(
        '/repos/%s/%s/%s/%s/reactions', delete $args->{user},
        delete $args->{repo},           $prefix,
        delete $args->{$id_key}
    );
}

sub _create {
    my ( $self, $prefix, $id_key, $args ) = @_;
    my $path = $self->_path( $prefix, $id_key, $args );
    croak 'Missing key in parameters: data (hashref)'
        unless ref $args->{data} eq 'HASH';
    my $content = $args->{data}{content};
    croak 'Invalid content. Valid values: ' . join q{, }, @CONTENT
        unless defined $content && $CONTENT{$content};
    return $self->request(
        method => 'POST',
        path   => $path,
        %$args,
    );
}

sub _delete {
    my ( $self, $prefix, $id_key, $args ) = @_;
    croak 'Missing key in parameters: reaction_id'
        unless $args->{reaction_id};
    my $path = $self->_path( $prefix, $id_key, $args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '%s/%s', $path, delete $args->{reaction_id} ),
        %$args,
    );
}

sub _list {
    my ( $self, $prefix, $id_key, $args ) = @_;
    return $self->request(
        method => 'GET',
        path   => $self->_path( $prefix, $id_key, $args ),
        %$args,
    );
}

1;
