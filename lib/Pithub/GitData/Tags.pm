package Pithub::GitData::Tags;

# ABSTRACT: Github v3 Git Data Tags API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method create

=over

=item *

Create a Tag

Note that creating a tag object does not create the reference that
makes a tag in Git. If you want to create an annotated tag in Git,
you have to do this call to create the tag object, and then create
the C<< refs/tags/[tag] >> reference. If you want to create a
lightweight tag, you simply have to create the reference - this
call would be unnecessary.

    POST /repos/:user/:repo/git/tags

Examples:

    my $t = Pithub::GitData::Tags->new;
    my $result = $t->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            tagger => {
                date  => '2010-04-10T14:10:01-07:00',
                email => 'plu@cpan.org',
                name  => 'Johannes Plunien',
            },
            message => 'Tagged v0.1',
            object  => '827efc6d56897b048c772eb4087f854f46256132',
            tag     => 'v0.1',
            type    => 'commit',
        }
    );

=back

Parameters in C<< data >> hashref:

Parameters

=over

=item *

B<tag>: String of the tag

=item *

B<message>: String of the tag message

=item *

B<object>: String of the SHA of the git object this is tagging

=item *

B<type>: String of the type of the object we’re tagging.
Normally this is a commit but it can also be a tree or a blob.

=item *

B<tagger.name>: String of the name of the author of the tag

=item *

B<tagger.email>: String of the email of the author of the tag

=item *

B<tagger.date>: Timestamp of when this object was tagged

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/git/tags', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Tag

    GET /repos/:user/:repo/git/tags/:sha

Examples:

    my $t = Pithub::GitData::Tags->new;
    my $result = $t->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/tags/%s', delete $args{user}, delete $args{repo}, delete $args{sha} ),
        %args,
    );
}

__PACKAGE__->meta->make_immutable;

1;
