package Pithub::GitData::Commits;

# ABSTRACT: Github v3 Git Data Commits API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Create a Commit

    POST /repos/:user/:repo/git/commits

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

B<message>: mandatory string, the commit message

=item *

B<tree>: mandatory string, the SHA of the tree object this commit
points to

=item *

B<parents>: mandatory arrayref of the SHAs of the commits that were
the parents of this commit. If omitted or empty, the commit will be
written as a root commit. For a single parent, an array of one SHA
should be provided, for a merge commit, an array of more than one
should be provided points to.

=back

Optional Parameters in the C<< data >> hashref:

The committer section is optional and will be filled with the author
data if omitted. If the author section is omitted, it will be filled
in with the authenticated users information and the current date.

=over

=item *

B<author>: hashref, having following keys:

=over

=item *

B<name>: string of the name of the author of the commit

=item *

B<email>: string of the email of the author of the commit

=item *

B<date>: timestamp of when this commit was authored

=back

=item *

B<committer>: hashref, having following keys:

=over

=item *

B<name>: string of the name of the committer of the commit

=item *

B<email>: string of the email of the committer of the commit

=item *

B<date>: timestamp of when this commit was committed

=back

=back

=back

Examples:

    my $c = Pithub::GitData::Commits->new;
    my $result = $c->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            author => {
                date  => '2008-07-09T16:13:30+12:00',
                email => 'schacon@gmail.com',
                name  => 'Scott Chacon',
            },
            message => 'my commit message',
            parents => ['7d1b31e74ee336d15cbd21741bc88a537ed063a0'],
            tree    => '827efc6d56897b048c772eb4087f854f46256132',
        }
    );

Response: B<Status: 201 Created>

    {
        "sha": "7638417db6d59f3c431d3e1f261cc637155684cd",
        "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/7638417db6d59f3c431d3e1f261cc637155684cd",
        "author": {
            "date": "2008-07-09T16:13:30+12:00",
            "name": "Scott Chacon",
            "email": "schacon@gmail.com"
        },
        "committer": {
            "date": "2008-07-09T16:13:30+12:00",
            "name": "Scott Chacon",
            "email": "schacon@gmail.com"
        },
        "message": "my commit message",
        "tree": {
            "url": "https://api.github.com/repos/octocat/Hello-World/git/trees/827efc6d56897b048c772eb4087f854f46256132",
            "sha": "827efc6d56897b048c772eb4087f854f46256132"
        },
        "parents": [
        {
            "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/7d1b31e74ee336d15cbd21741bc88a537ed063a0",
            "sha": "7d1b31e74ee336d15cbd21741bc88a537ed063a0"
        }
        ]
    }

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/git/commits', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Commit

    GET /repos/:user/:repo/git/commits/:sha

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

    my $c = Pithub::GitData::Commits->new;
    my $result = $c->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'b7cdea6830e128bc16c2b75efd99842d971666e2',
    );

Response: B<Status: 200 OK>

    {
        "sha": "7638417db6d59f3c431d3e1f261cc637155684cd",
        "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/7638417db6d59f3c431d3e1f261cc637155684cd",
        "author": {
            "date": "2010-04-10T14:10:01-07:00",
            "name": "Scott Chacon",
            "email": "schacon@gmail.com"
        },
        "committer": {
            "date": "2010-04-10T14:10:01-07:00",
            "name": "Scott Chacon",
            "email": "schacon@gmail.com"
        },
        "message": "added readme, because im a good github citizen\n",
        "tree": {
            "url": "https://api.github.com/repos/octocat/Hello-World/git/trees/691272480426f78a0138979dd3ce63b77f706feb",
            "sha": "691272480426f78a0138979dd3ce63b77f706feb"
        },
        "parents": [
        {
            "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/1acc419d4d6a9ce985db7be48c6349a0475975b5",
            "sha": "1acc419d4d6a9ce985db7be48c6349a0475975b5"
        }
        ]
    }

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/commits/%s', delete $args{user}, delete $args{repo}, delete $args{sha} ),
        %args,
    );
}

1;
