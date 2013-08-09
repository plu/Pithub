use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

# These tests may break very easily because data on Github can and will change, of course.
# And they also might fail once the ratelimit has been reached.
SKIP: {
    skip 'Set PITHUB_TEST_LIVE_DATA to true to run these tests', 1 unless $ENV{PITHUB_TEST_LIVE_DATA};

    my $p = Pithub->new;

    # Pithub::GitData::Blobs->get
    {
        my $result = $p->git_data->blobs->get( user => 'plu', repo => 'Pithub', sha => '5ab76a4e0253f527bf5bee2a02072261c8d2b811' );
        is $result->success, 1, 'Pithub::GitData::Blobs->get successful';
        eq_or_diff $result->content, {
            'content' => 'UmV2aXNpb24gaGlzdG9yeSBmb3Ige3skZGlzdC0+bmFtZX19Cgp7eyRORVhU
fX0KICAgICAgICAgIC0gbWlub3IgUE9EIGNoYW5nZXMKCjAuMDEwMDAgICAy
MDExLTA2LTI3IDEyOjM2OjQ0IEFzaWEvRHViYWkKICAgICAgICAgIC0gZmly
c3QgcmVsZWFzZQo=
',
            'encoding' => 'base64',
            'sha'      => '5ab76a4e0253f527bf5bee2a02072261c8d2b811',
            'size'     => 146,
            'url'      => 'https://api.github.com/repos/plu/Pithub/git/blobs/5ab76a4e0253f527bf5bee2a02072261c8d2b811'
          },
          'Pithub::GitData::Blobs->get content';
    }

    # Pithub::GitData::Commits->get
    {
        my $result = $p->git_data->commits->get( user => 'plu', repo => 'Pithub', sha => '20f946f933a911253e480eb0e9feced1e36dbd45' );
        is $result->success, 1, 'Pithub::GitData::Commits->get successful';
        eq_or_diff $result->content,
          {
            'author' => {
                'date'  => '2011-06-28T04:38:09Z',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'committer' => {
                'date'  => '2011-06-28T04:56:24Z',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'message' => "Add Changes file.",
            'html_url' => 'https://github.com/plu/Pithub/commits/20f946f933a911253e480eb0e9feced1e36dbd45',
            'parents' => [
                {
                    'html_url' => 'https://github.com/plu/Pithub/commits/9616d4f1515bf4de1a32f85a8fa1b1cc441da164',
                    'sha' => '9616d4f1515bf4de1a32f85a8fa1b1cc441da164',
                    'url' => 'https://api.github.com/repos/plu/Pithub/git/commits/9616d4f1515bf4de1a32f85a8fa1b1cc441da164'
                }
            ],
            'sha'  => '20f946f933a911253e480eb0e9feced1e36dbd45',
            'tree' => {
                'sha' => '8776942cb834e5107317403a8a167e30167f8056',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/8776942cb834e5107317403a8a167e30167f8056'
            },
            'url' => 'https://api.github.com/repos/plu/Pithub/git/commits/20f946f933a911253e480eb0e9feced1e36dbd45'
          },
          'Pithub::GitData::Commits->get content';
    }

    # Pithub::GitData::References->get
    {
        my $result = $p->git_data->references->get( user => 'plu', repo => 'Pithub', ref => 'tags/v0.01000' );
        is $result->success, 1, 'Pithub::GitData::References->get successful';
        eq_or_diff $result->content,
          {
            'object' => {
                'sha'  => '1c5230f42d6d3e376162591f223fc4130d671937',
                'type' => 'commit',
                'url'  => 'https://api.github.com/repos/plu/Pithub/git/commits/1c5230f42d6d3e376162591f223fc4130d671937'
            },
            'ref' => 'refs/tags/v0.01000',
            'url' => 'https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01000'
          },
          'Pithub::GitData::References->get content';
    }

    # Pithub::GitData::References->list
    {
        my $result = $p->git_data->references->list( user => 'plu', repo => 'Pithub', ref => 'tags' );
        my @tags = splice @{ $result->content }, 0, 2;
        is $result->success, 1, 'Pithub::GitData::References->list successful';
        eq_or_diff \@tags,
          [
            {
                'object' => {
                    'sha'  => '1c5230f42d6d3e376162591f223fc4130d671937',
                    'type' => 'commit',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/commits/1c5230f42d6d3e376162591f223fc4130d671937'
                },
                'ref' => 'refs/tags/v0.01000',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01000'
            },
            {
                'object' => {
                    'sha'  => 'ef328a0679a992bd2c0ac537cf19d379f1c8d177',
                    'type' => 'tag',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/tags/ef328a0679a992bd2c0ac537cf19d379f1c8d177'
                },
                'ref' => 'refs/tags/v0.01001',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01001'
            }
          ],
          'Pithub::GitData::References->list content';
    }

    # Pithub::GitData::Trees->get
    {
        my $result = $p->git_data->trees->get( user => 'plu', repo => 'Pithub', sha => '7331484696162bf7b5c97de488fd2c1289fd175c' );
        is $result->success, 1, 'Pithub::GitData::Trees->get successful';
        eq_or_diff $result->content,
          {
            'sha'  => '7331484696162bf7b5c97de488fd2c1289fd175c',
            'tree' => [
                {
                    'mode' => '100644',
                    'path' => '.gitignore',
                    'sha'  => '39c3bf7b7e4a25b8673083311cfba2d2389f705e',
                    'size' => 179,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/39c3bf7b7e4a25b8673083311cfba2d2389f705e'
                },
                {
                    'mode' => '100644',
                    'path' => 'dist.ini',
                    'sha'  => 'fb4c94cc3717143903b7d0aae1b12e30653a8e7c',
                    'size' => 210,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/fb4c94cc3717143903b7d0aae1b12e30653a8e7c'
                },
                {
                    'mode' => '040000',
                    'path' => 'lib',
                    'sha'  => '7d2b61bafb9a703b393af386e4bcc350ad2c9aa9',
                    'type' => 'tree',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/trees/7d2b61bafb9a703b393af386e4bcc350ad2c9aa9'
                }
            ],
            'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/7331484696162bf7b5c97de488fd2c1289fd175c'
          },
          'Pithub::GitData::Trees->get content';

        my $result_recursive = $p->git_data->trees->get( user => 'plu', repo => 'Pithub', sha => '7331484696162bf7b5c97de488fd2c1289fd175c', recursive => 1, );
        is $result_recursive->success, 1, 'Pithub::GitData::Trees->get successful';
        eq_or_diff $result_recursive->content,
          {
            'sha'  => '7331484696162bf7b5c97de488fd2c1289fd175c',
            'tree' => [
                {
                    'mode' => '100644',
                    'path' => '.gitignore',
                    'sha'  => '39c3bf7b7e4a25b8673083311cfba2d2389f705e',
                    'size' => 179,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/39c3bf7b7e4a25b8673083311cfba2d2389f705e'
                },
                {
                    'mode' => '100644',
                    'path' => 'dist.ini',
                    'sha'  => 'fb4c94cc3717143903b7d0aae1b12e30653a8e7c',
                    'size' => 210,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/fb4c94cc3717143903b7d0aae1b12e30653a8e7c'
                },
                {
                    'mode' => '040000',
                    'path' => 'lib',
                    'sha'  => '7d2b61bafb9a703b393af386e4bcc350ad2c9aa9',
                    'type' => 'tree',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/trees/7d2b61bafb9a703b393af386e4bcc350ad2c9aa9'
                },
                {
                    'mode' => '100644',
                    'path' => 'lib/Pithub.pm',
                    'sha'  => 'b493b43e8016b86550c065fcf83df537052ad371',
                    'size' => 121,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/b493b43e8016b86550c065fcf83df537052ad371'
                }
            ],
            'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/7331484696162bf7b5c97de488fd2c1289fd175c'
          },
          'Pithub::GitData::Trees->get content recursive';
    }
}

# Following tests require a token and should only be run on a test
# account since they will create a lot of activity in that account.
SKIP: {
    skip 'PITHUB_TEST_TOKEN required to run this test - DO NOT DO THIS UNLESS YOU KNOW WHAT YOU ARE DOING', 1 unless $ENV{PITHUB_TEST_TOKEN};

    my $org      = Pithub::Test->test_account->{org};
    my $org_repo = Pithub::Test->test_account->{org_repo};
    my $repo     = Pithub::Test->test_account->{repo};
    my $user     = Pithub::Test->test_account->{user};
    my $p        = Pithub->new(
        user  => $user,
        repo  => $repo,
        token => $ENV{PITHUB_TEST_TOKEN}
    );

    {

        # Pithub::GitData::Blobs->create
        my $blob_sha = $p->git_data->blobs->create(
            data => {
                content  => 'Content of the blob',
                encoding => 'utf-8',
            }
        )->content->{sha};
        ok $blob_sha, 'Pithub::GitData::Blobs->create returned a SHA';

        my $result = $p->git_data->blobs->get( sha => $blob_sha );
        is $result->content->{content}, "Q29udGVudCBvZiB0aGUgYmxvYg==\n", 'Pithub::GitData::Blobs->get content after create';
        is $result->content->{encoding}, 'base64', 'Pithub::GitData::Blobs->get encoding after create';

        # Pithub::GitData::References->get
        my $master_sha = $p->git_data->references->get( ref => 'heads/master' )->content->{object}{sha};
        ok $master_sha, 'Pithub::GitData::Trees->get returned a SHA';

        # Pithub::GitData::Commits->get
        my $base_tree_sha = $p->git_data->commits->get( sha => $master_sha )->content->{tree}{sha};
        ok $master_sha, 'Pithub::GitData::Commits->get returned a tree SHA';

        # Pithub::GitData::Trees->create
        my $tree_sha = $p->git_data->trees->create(
            data => {
                base_tree => $base_tree_sha,
                tree      => [
                    {
                        path => "${blob_sha}.blob",
                        mode => '100644',
                        type => 'blob',
                        sha  => $blob_sha,
                    }
                ],
            }
        )->content->{sha};
        ok $tree_sha, 'Pithub::GitData::Trees->create returned a SHA';

        # Pithub::GitData::Commits->create
        my $commit_sha = $p->git_data->commits->create(
            data => {
                message => 'my commit message',
                parents => [$master_sha],
                tree    => $tree_sha,
            }
        )->content->{sha};
        ok $commit_sha, 'Pithub::GitData::Commits->create returned a SHA';

        # Pithub::GitData::References->update
        ok $p->git_data->references->update(
            ref  => 'heads/master',
            data => { sha => $commit_sha }
        )->success, 'Pithub::GitData::References->update successful';
    }
}

done_testing;
