package Pithub::GitData::Trees;

# ABSTRACT: Github v3 Git Data Trees API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';

=method create

The tree creation API will take nested entries as well. If both a
tree and a nested path modifying that tree are specified, it will
overwrite the contents of that tree with the new path contents and
write a new tree out.

=over

=item *

Create a Tree

    POST /repos/:user/:repo/git/trees

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

B<base_tree>: optional String of the SHA1 of the tree you want to
update with new data.

=item *

B<tree>: mandatory arrayref of hashrefs, having following keys:

=over

=item *

B<path>: mandatory string of the file referenced in the tree.

=item *

B<mode>: mandatory string of the file mode - one of C<< 100644 >>
for file (blob), C<< 100755 >> for executable (blob), C<< 040000 >>
for subdirectory (tree), C<< 160000 >> for submodule (commit) or
C<< 120000 >> for a blob that specifies the path of a symlink.

=item *

B<type>: mandatory string of C<< blob >>, C<< tree >>, C<< commit >>.

=item *

B<sha>: mandatory string of SHA1 checksum ID of the object in the tree.

=item *

B<content>: String of content you want this file to have - GitHub will
write this blob out and use that SHA for this entry. Use either this
or C<< tree.sha >>.

=back

=back

=back

Examples:

    my $t = Pithub::GitData::Trees->new;
    my $result = $t->create(
        user => 'octocat',
        repo => 'Hello-World',
        data => {
            tree => [
                {
                    path => 'file.rb',
                    mode => '100644',
                    type => 'blob',
                    sha  => '7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b',
                }
            ]
        }
    );

Response: B<Status: 201 Created>

    {
        "sha": "cd8274d15fa3ae2ab983129fb037999f264ba9a7",
        "url": "https://api.github.com/repo/octocat/Hello-World/trees/cd8274d15fa3ae2ab983129fb037999f264ba9a7",
        "tree": [
        {
            "path": "file.rb",
            "mode": "100644",
            "type": "blob",
            "size": 132,
            "sha": "7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b",
            "url": "https://api.github.com/octocat/Hello-World/git/blobs/7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b"
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
        path   => sprintf( '/repos/%s/%s/git/trees', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

=method get

=over

=item *

Get a Tree

    GET /repos/:user/:repo/git/trees/:sha

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<sha>: mandatory string

=item *

B<recursive>: optional boolean

=back

Examples:

    my $t = Pithub::GitData::Trees->new;
    my $result = $t->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6'
    );

Response: B<Status: 200 OK>

    {
        "sha": "9fb037999f264ba9a7fc6274d15fa3ae2ab98312",
        "url": "https://api.github.com/repo/octocat/Hello-World/trees/9fb037999f264ba9a7fc6274d15fa3ae2ab98312",
        "tree": [
        {
            "path": "file.rb",
            "mode": "100644",
            "type": "blob",
            "size": 30,
            "sha": "44b4fc6d56897b048c772eb4087f854f46256132",
            "url": "https://api.github.com/octocat/Hello-World/git/blobs/44b4fc6d56897b048c772eb4087f854f46256132"
        },
        {
            "path": "subdir",
            "mode": "040000",
            "type": "tree",
            "sha": "f484d249c660418515fb01c2b9662073663c242e",
            "url": "https://api.github.com/octocat/Hello-World/git/blobs/f484d249c660418515fb01c2b9662073663c242e"
        },
        {
            "path": "exec_file",
            "mode": "100755",
            "type": "blob",
            "size": 75,
            "sha": "45b983be36b73c0788dc9cbcb76cbb80fc7bb057",
            "url": "https://api.github.com/octocat/Hello-World/git/blobs/45b983be36b73c0788dc9cbcb76cbb80fc7bb057"
        }
        ]
    }

=item *

Get a Tree Recursively

    GET /repos/:user/:repo/git/trees/:sha?recursive=1

Parameters:

=over

=item *

B<user>: mandatory string

=item *

B<repo>: mandatory string

=item *

B<sha>: mandatory string

=item *

B<recursive>: optional boolean

=back

Examples:

    my $t = Pithub::GitData::Trees->new;
    my $result = $t->get(
        user      => 'plu',
        repo      => 'Pithub',
        sha       => 'df21b2660fb6',
        recursive => 1,
    );

Response: B<Status: 200 OK>

    {
        "sha": "fc6274d15fa3ae2ab983129fb037999f264ba9a7",
        "url": "https://api.github.com/repo/octocat/Hello-World/trees/fc6274d15fa3ae2ab983129fb037999f264ba9a7",
        "tree": [
        {
            "path": "subdir/file.txt",
            "mode": "100644",
            "type": "blob",
            "size": 132,
            "sha": "7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b",
            "url": "https://api.github.com/octocat/Hello-World/git/7c258a9869f33c1e1e1f74fbb32f07c86cb5a75b"
        }
        ]
    }

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    my $path = sprintf( '/repos/%s/%s/git/trees/%s', $args{user}, $args{repo}, $args{sha} );
    my %params = ();
    if ( $args{recursive} ) {
        $params{recursive} = 1;
    }
    return $self->request(
        method => 'GET',
        path   => $path,
        params => \%params,
        %args,
    );
}

1;
