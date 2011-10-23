package Pithub::GitData::Tags;

# ABSTRACT: Github v3 Git Data Tags API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=head1 DESCRIPTION

This tags api only deals with tag objects - so only annotated tags,
not lightweight tags.

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

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<tag>: mandatory string of the tag

=item *

B<message>: mandatory string of the tag message

=item *

B<object>: mandatory stringof the SHA of the git object this is tagging

=item *

B<type>: mandatory string of the type of the object we're tagging.
Normally this is a C<< commit >> but it can also be a C<< tree >>
or a C<< blob >>.

=item *

B<tagger>: mandatory hashref, having following keys:

=over

=item *

B<name>: string of the name of the author of the tag

=item *

B<email>: string of the email of the author of the tag

=item *

B<date>: timestamp of when this commit was tagged

=back

=back

=back

Examples:

    my $t = Pithub::GitData::Tags->new;
    my $result = $t->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            tagger => {
                date  => '2011-06-17T14:53:35-07:00',
                email => 'schacon@gmail.com',
                name  => 'Scott Chacon',
            },
            message => 'initial version',
            object  => 'c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c',
            tag     => 'v0.0.1',
            type    => 'commit',
        }
    );

Response: B<Status: 201 Created>

    {
        "tag": "v0.0.1",
        "sha": "940bd336248efae0f9ee5bc7b2d5c985887b16ac",
        "url": "https://api.github.com/repos/octocat/Hello-World/git/tags/940bd336248efae0f9ee5bc7b2d5c985887b16ac",
        "message": "initial version\n",
        "tagger": {
            "name": "Scott Chacon",
            "email": "schacon@gmail.com",
            "date": "2011-06-17T14:53:35-07:00"
        },
        "object": {
            "type": "commit",
            "sha": "c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c",
            "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c"
        }
    }

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

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<sha>: mandatory string

=back

Examples:

    my $t = Pithub::GitData::Tags->new;
    my $result = $t->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

Response: B<Status: 200 OK>

    {
        "tag": "v0.0.1",
        "sha": "940bd336248efae0f9ee5bc7b2d5c985887b16ac",
        "url": "https://api.github.com/repos/octocat/Hello-World/git/tags/940bd336248efae0f9ee5bc7b2d5c985887b16ac",
        "message": "initial version\n",
        "tagger": {
            "name": "Scott Chacon",
            "email": "schacon@gmail.com",
            "date": "2011-06-17T14:53:35-07:00"
        },
        "object": {
            "type": "commit",
            "sha": "c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c",
            "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c"
        }
    }

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

1;
