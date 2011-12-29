package Pithub::Gists;

# ABSTRACT: Github v3 Gists API

use Moo;
use Carp qw(croak);
use Pithub::Gists::Comments
extends 'Pithub::Base';

=method comments

Provides access to L<Pithub::Gists::Comments>.

=cut

sub comments {
    return shift->_create_instance('Pithub::Gists::Comments');
}

=method create

=over

=item *

Create a gist

    POST /gists

Parameters:

=over

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<description>: optional string

=item *

B<public>: mandatory boolean

=item *

B<files>: mandatory hashref, please see examples section below

=back

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->create(
        data => {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );
    if ( $result->success ) {
        printf "The new gist is available at %s\n", $result->content->{html_url};
    }

Response: B<Status: 201 Created>

    {
        "url": "https://api.github.com/gists/1",
        "id": "1",
        "description": "description of gist",
        "public": true,
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "files": {
            "ring.erl": {
                "size": 932,
                "filename": "ring.erl",
                "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl",
                "content": "contents of gist"
            }
        },
        "comments": 0,
        "git_pull_url": "git://gist.github.com/1.git",
        "git_push_url": "git@gist.github.com:1.git",
        "created_at": "2010-04-14T02:15:15Z",
        "forks": [
        {
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "url": "https://api.github.com/gists/5",
            "created_at": "2011-04-14T16:00:49Z"
        }
        ],
        "history": [
        {
            "url": "https://api.github.com/gists/1/57a7f021a713b1c5a6a199b54cc514735d2d462f",
            "version": "57a7f021a713b1c5a6a199b54cc514735d2d462f",
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "change_status": {
                "deletions": 0,
                "additions": 180,
                "total": 180
            },
            "committed_at": "2010-04-14T02:15:15Z"
        }
        ]
    }

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'POST',
        path   => '/gists',
        %args,
    );
}

=method delete

=over

=item *

Delete a gist

    DELETE /gists/:id

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->delete( gist_id => 784612 );
    if ( $result->success ) {
        print "The gist 784612 has been deleted\n";
    }

Response: B<Status: 204 No Content>

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/gists/%s', delete $args{gist_id} ),
        %args,
    );
}

=method fork

=over

=item *

Fork a gist

    POST /gists/:id/forks

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->fork( gist_id => 784612 );
    if ( $result->success ) {
        printf "The gist 784612 has been forked: %s\n", $result->content->{html_url};
    }

Response: B<Status: 201 Created>

    {
        "url": "https://api.github.com/gists/1",
        "id": "1",
        "description": "description of gist",
        "public": true,
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "files": {
            "ring.erl": {
                "size": 932,
                "filename": "ring.erl",
                "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl",
                "content": "contents of gist"
            }
        },
        "comments": 0,
        "git_pull_url": "git://gist.github.com/1.git",
        "git_push_url": "git@gist.github.com:1.git",
        "created_at": "2010-04-14T02:15:15Z"
    }

=back

=cut

sub fork {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'POST',
        path   => sprintf( '/gists/%s/forks', delete $args{gist_id} ),
        %args,
    );
}

=method get

=over

=item *

Get a single gist

    GET /gists/:id

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->get( gist_id => 784612 );
    if ( $result->success ) {
        print $result->content->{html_url};
    }

Response: B<Status: 200 OK>

    {
        "url": "https://api.github.com/gists/1",
        "id": "1",
        "description": "description of gist",
        "public": true,
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "files": {
            "ring.erl": {
                "size": 932,
                "filename": "ring.erl",
                "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl",
                "content": "contents of gist"
            }
        },
        "comments": 0,
        "git_pull_url": "git://gist.github.com/1.git",
        "git_push_url": "git@gist.github.com:1.git",
        "created_at": "2010-04-14T02:15:15Z",
        "forks": [
        {
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "url": "https://api.github.com/gists/5",
            "created_at": "2011-04-14T16:00:49Z"
        }
        ],
        "history": [
        {
            "url": "https://api.github.com/gists/1/57a7f021a713b1c5a6a199b54cc514735d2d462f",
            "version": "57a7f021a713b1c5a6a199b54cc514735d2d462f",
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "change_status": {
                "deletions": 0,
                "additions": 180,
                "total": 180
            },
            "committed_at": "2010-04-14T02:15:15Z"
        }
        ]
    }

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/gists/%s', delete $args{gist_id} ),
        %args,
    );
}

=method is_starred

=over

=item *

Check if a gist is starred

    GET /gists/:id/star

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->is_starred( gist_id => 784612 );

Response: B<Status: 204 No Content> / C<< Status: 404 Not Found >>

=back

=cut

sub is_starred {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/gists/%s/star', delete $args{gist_id} ),
        %args,
    );
}

=method list

=over

=item *

List a user's gists:

    GET /users/:user/gists

Parameters:

=over

=item *

B<user>: string

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list( user => 'miyagawa' );
    if ( $result->success ) {
        while ( my $row = $result->next ) {
            printf "%s => %s\n", $row->{html_url}, $row->{description} || 'no description';
        }
    }

=item *

List the authenticated user's gists or if called anonymously,
this will returns all public gists:

    GET /gists

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list;

=item *

List all public gists:

    GET /gists/public

Parameters:

=over

=item *

B<public>: boolean

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list( public => 1 );

=item *

List the authenticated user's starred gists:

    GET /gists/starred

Parameters:

=over

=item *

B<starred>: boolean

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->list( starred => 1 );

Response: B<Status: 200 OK>

    [
        {
            "url": "https://api.github.com/gists/1",
            "id": "1",
            "description": "description of gist",
            "public": true,
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "files": {
                "ring.erl": {
                    "size": 932,
                    "filename": "ring.erl",
                    "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl",
                    "content": "contents of gist"
                }
            },
            "comments": 0,
            "git_pull_url": "git://gist.github.com/1.git",
            "git_push_url": "git@gist.github.com:1.git",
            "created_at": "2010-04-14T02:15:15Z"
        }
    ]

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = delete $args{user} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/users/%s/gists', $user ),
            %args,
        );
    }
    elsif ( delete $args{starred} ) {
        return $self->request(
            method => 'GET',
            path   => '/gists/starred',
            %args,
        );
    }
    elsif ( delete $args{public} ) {
        return $self->request(
            method => 'GET',
            path   => '/gists/public',
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => '/gists',
        %args,
    );
}

=method star

=over

=item *

Star a gist

    PUT /gists/:id/star

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->star( gist_id => 784612 );

Response: B<Status: 204 No Content>

=back

=cut

sub star {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/gists/%s/star', delete $args{gist_id} ),
        %args,
    );
}

=method unstar

=over

=item *

Unstar a gist

    DELETE /gists/:id/star

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $g = Pithub::Gists->new;
    my $result = $g->unstar( gist_id => 784612 );

Response: B<Status: 204 No Content>

=back

=cut

sub unstar {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/gists/%s/star', delete $args{gist_id} ),
        %args,
    );
}

=method update

=over

=item *

Edit a gist

    PATCH /gists/:id

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<description>: optional string

=item *

B<public>: mandatory boolean

=item *

B<files>: mandatory hashref, please see examples section below

NOTE: All files from the previous version of the gist are carried
over by default if not included in the hash. Deletes can be
performed by including the filename with a null hash.

=back

=back

Examples:

    my $g      = Pithub::Gists->new;
    my $result = $g->update(
        gist_id => 784612,
        data    => {
            description => 'the description for this gist',
            files       => {
                'file1.txt'    => { content => 'updated file contents' },
                'old_name.txt' => {
                    filename => 'new_name.txt',
                    content  => 'modified contents'
                },
                'new_file.txt'         => { content => 'a new file' },
                'delete_this_file.txt' => undef
            }
        }
    );

Response: B<Status: 200 OK>

    {
        "url": "https://api.github.com/gists/1",
        "id": "1",
        "description": "description of gist",
        "public": true,
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "files": {
            "ring.erl": {
                "size": 932,
                "filename": "ring.erl",
                "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl",
                "content": "contents of gist"
            }
        },
        "comments": 0,
        "git_pull_url": "git://gist.github.com/1.git",
        "git_push_url": "git@gist.github.com:1.git",
        "created_at": "2010-04-14T02:15:15Z",
        "forks": [
        {
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "url": "https://api.github.com/gists/5",
            "created_at": "2011-04-14T16:00:49Z"
        }
        ],
        "history": [
        {
            "url": "https://api.github.com/gists/1/57a7f021a713b1c5a6a199b54cc514735d2d462f",
            "version": "57a7f021a713b1c5a6a199b54cc514735d2d462f",
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "change_status": {
                "deletions": 0,
                "additions": 180,
                "total": 180
            },
            "committed_at": "2010-04-14T02:15:15Z"
        }
        ]
    }

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/gists/%s', delete $args{gist_id} ),
        %args,
    );
}

1;
