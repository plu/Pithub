#!/usr/bin/env perl
use strict;
use warnings;
use File::Slurp;
use Pithub::GitData;

my $git = Pithub::GitData->new(
    repo  => 'Pithub',
    token => $ENV{GITHUB_TOKEN},
    user  => 'plu',
);

my $content = File::Slurp::read_file(__FILE__);

# the encoding can also be 'base64', if necessary
my $blob = $git->blobs->create(
    data => {
        content  => $content,
        encoding => 'utf-8',
    }
);

die "Could not create blob" unless $blob->success;

# we need the current master reference, actually just its SHA
my $master = $git->references->get( ref => 'heads/master' );

die "Could not get the heads/master reference" unless $master->success;

# and we need the full commit of this SHA. Later we will
# extract the tree SHA this commit belongs to.
my $base_commit = $git->commits->get( sha => $master->content->{object}{sha} );

die "Could not get the base commit" unless $base_commit->success;

# create a new tree, based on the old one, that adds the new blob
my $tree = $git->trees->create(
    data => {
        base_tree => $base_commit->content->{tree}{sha},
        tree      => [
            {
                path => 'examples/gitdata_commit.pl',
                mode => '100755',
                type => 'blob',
                sha  => $blob->content->{sha},
            }
        ],
    }
);

die "Could not create the new tree" unless $tree->success;

# create a new commit based on the new tree and
# having the current master as a parent
my $commit = $git->commits->create(
    data => {
        message => 'Add examples/gitdata_commit.pl.',
        parents => [ $master->content->{object}{sha} ],
        tree    => $tree->content->{sha},
    }
);

die "Could not create the commit" unless $commit->success;

# finally point the master branch to the new commit
my $reference = $git->references->update(
    ref  => 'heads/master',
    data => { sha => $commit->content->{sha} }
);

die "Could not update the heads/master reference" unless $reference->success;

print "Done.\n";
