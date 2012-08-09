package Pithub::GitData::References;

# ABSTRACT: Github v3 Git Data References API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

=over

=item *

Create a Reference

    POST /repos/:user/:repo/git/refs

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

B<ref>: mandatory string of the name of the fully qualified
reference (ie: refs/heads/master). If it doesn't start with
'refs' and have at least two slashes, it will be rejected.

=item *

B<sha>: mandatory string of the SHA1 value to set this
reference to.

=back

=back

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            ref => 'refs/heads/master',
            sha => '827efc6d56897b048c772eb4087f854f46256132' .
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/git/refs', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Reference

    GET /repos/:user/:repo/git/refs/:ref

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<ref>: mandatory string

The key B<ref> must be formatted as C<< heads/branch >>, not just
C<< branch >>. For example, the call to get the data for a branch
named C<< sc/featureA >> would be: C<< heads/sc/featureA >>

=back

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->get(
        user => 'plu',
        repo => 'Pithub',
        ref  => 'heads/master'
    );

Response: B<Status: 200 OK>

    {
        "ref": "refs/heads/sc/featureA",
        "url": "https://api.github.com/repos/octocat/Hello-World/git/refs/heads/sc/featureA",
        "object": {
            "type": "commit",
            "sha": "aa218f56b14c9653891f9e74264a383fa43fefbd",
            "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/aa218f56b14c9653891f9e74264a383fa43fefbd"
        }
    }

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: ref' unless $args{ref};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/refs/%s', delete $args{user}, delete $args{repo}, delete $args{ref} ),
        %args,
    );
}

=method list

=over

=item *

Get all References

    GET /repos/:user/:repo/git/refs

This will return an array of all the references on the system,
including things like notes and stashes if they exist on the server.
Anything in the namespace, not just heads and tags, though that
would be the most common.

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=back

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->list(
        user => 'plu',
        repo => 'Pithub',
    );

=item *

You can also request a sub-namespace. For example, to get all the
tag references, you can call:

    GET /repos/:user/:repo/git/refs/tags

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<ref>: mandatory string

=back

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->list(
        user => 'plu',
        repo => 'Pithub',
        ref  => 'tags',
    );

Response: B<Status: 200 OK>

    [
        {
            "object": {
                "type": "commit",
                "sha": "1c5230f42d6d3e376162591f223fc4130d671937",
                "url": "https://api.github.com/repos/plu/Pithub/git/commits/1c5230f42d6d3e376162591f223fc4130d671937"
            },
            "ref": "refs/tags/v0.01000",
            "url": "https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01000"
        },
        {
            "object": {
                "type": "tag",
                "sha": "ef328a0679a992bd2c0ac537cf19d379f1c8d177",
                "url": "https://api.github.com/repos/plu/Pithub/git/tags/ef328a0679a992bd2c0ac537cf19d379f1c8d177"
            },
            "ref": "refs/tags/v0.01001",
            "url": "https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01001"
        }
    ]

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $ref = $args{ref} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/repos/%s/%s/git/refs/%s', delete $args{user}, delete $args{repo}, delete $args{ref} ),
            %args,
        );
    }
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/git/refs', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method update

=over

=item *

Update a Reference

    PATCH /repos/:user/:repo/git/refs/:ref

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<ref>: mandatory string

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<sha>: mandatory string of the SHA1 value to set this
reference to.

=item *

B<force>: optional boolean indicating whether to force the update or
to make sure the update is a fast-forward update. The default is
C<< false >> so leaving this out or setting it to C<< false >> will
make sure you're not overwriting work.

=back

=back

Examples:

    my $r = Pithub::GitData::References->new;
    my $result = $r->update(
        user => 'plu',
        repo => 'Pithub',
        ref  => 'tags/v1.0',
        data => {
            force => 1,
            sha   => 'aa218f56b14c9653891f9e74264a383fa43fefbd',
        }
    );

Response: B<Status: 200 OK>

    [
        {
            "ref": "refs/heads/sc/featureA",
            "url": "https://api.github.com/repos/octocat/Hello-World/git/refs/heads/sc/featureA",
            "object": {
                "type": "commit",
                "sha": "aa218f56b14c9653891f9e74264a383fa43fefbd",
                "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/aa218f56b14c9653891f9e74264a383fa43fefbd"
            }
        }
    ]

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: ref' unless $args{ref};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/git/refs/%s', delete $args{user}, delete $args{repo}, delete $args{ref} ),
        %args,
    );
}

1;
