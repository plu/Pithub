use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

SKIP: {
    skip 'Set PITHUB_TEST_LIVE to true to run this test', 1 unless $ENV{PITHUB_TEST_LIVE};

    my $p = Pithub->new;
    my $result = $p->request( GET => '/' );

    is $result->code,        200,  'HTTP status is 200';
    is $result->success,     1,    'Successful';
    is $result->raw_content, '{}', 'Empty JSON object';
    eq_or_diff $result->content, {}, 'Empty hashref';
}

# These tests may break very easily because data on Github can and will change, of course.
# And they also might fail once the ratelimit has been reached.
SKIP: {
    skip 'Set PITHUB_TEST_LIVE_DATA to true to run this test', 1 unless $ENV{PITHUB_TEST_LIVE_DATA};

    my $p = Pithub->new;

    # Pithub::Gists->get
    {
        my $result = $p->gists->get( gist_id => 1 );
        is $result->success, 1, 'Pithub::Gists->get successful';
        is $result->content->{created_at}, '2008-07-15T18:17:13Z', 'Pithub::Gists->get created_at';
    }

    # Pithub::Gists->list
    {
        my $result = $p->gists->list( public => 1 );
        is $result->success, 1, 'Pithub::Gists->list successful';
        while ( my $row = $result->next ) {
            ok $row->{id}, "Pithub::Gists->list has id: $row->{id}";
            like $row->{url}, qr{https://api.github.com/gists/\d+$}, "Pithub::Gists->list has url: $row->{url}";
        }
    }

    # Pithub::Gists::Comments->list
    {
        my $result = $p->gists->comments->list( gist_id => 1 );
        is $result->success, 1, 'Pithub::Gists::Comments->list successful';
        while ( my $row = $result->next ) {
            ok $row->{id}, "Pithub::Gists::Comments->list has id: $row->{id}";
            like $row->{url}, qr{https://api.github.com/gists/comments/\d+$}, "Pithub::Gists::Comments->list has url: $row->{url}";
        }
    }

    # Pithub::GitData::Blobs->create
    # Pithub::GitData::Blobs->get
    {
        my $result = $p->git_data->blobs->get( user => 'plu', repo => 'Pithub', sha => '20f946f933a911253e480eb0e9feced1e36dbd45' );
        is $result->success, 1, 'Pithub::GitData::Blobs->get successful';
        eq_or_diff $result->content, {
            'content' => 'dHJlZSA4Nzc2OTQyY2I4MzRlNTEwNzMxNzQwM2E4YTE2N2UzMDE2N2Y4MDU2
CnBhcmVudCA5NjE2ZDRmMTUxNWJmNGRlMWEzMmY4NWE4ZmExYjFjYzQ0MWRh
MTY0CmF1dGhvciBKb2hhbm5lcyBQbHVuaWVuIDxwbHVAcHFwcS5kZT4gMTMw
OTIzNTg4OSArMDQwMApjb21taXR0ZXIgSm9oYW5uZXMgUGx1bmllbiA8cGx1
QHBxcHEuZGU+IDEzMDkyMzY5ODQgKzA0MDAKCkFkZCBDaGFuZ2VzIGZpbGUu
Cg==
',
            'encoding' => 'base64',
            'sha'      => '20f946f933a911253e480eb0e9feced1e36dbd45',
            'size'     => 226,
            'url'      => 'https://api.github.com/repos/plu/Pithub/git/blobs/20f946f933a911253e480eb0e9feced1e36dbd45'
          },
          'Pithub::GitData::Blobs->get content';
    }

    # Pithub::GitData::Commits->create
    # Pithub::GitData::Commits->get
    {
        my $result = $p->git_data->commits->get( user => 'plu', repo => 'Pithub', sha => '20f946f933a911253e480eb0e9feced1e36dbd45' );
        is $result->success, 1, 'Pithub::GitData::Commits->get successful';
        eq_or_diff $result->content,
          {
            'author' => {
                'date'  => '2011-06-27T21:38:09-07:00',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'committer' => {
                'date'  => '2011-06-27T21:56:24-07:00',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'message' => "Add Changes file.\n",
            'parents' => [
                {
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

    # Pithub::GitData::References->create

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

    # Pithub::GitData::References->update

    # Pithub::GitData::Tags->get
    # Pithub::GitData::Tags->create

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

    # Pithub::GitData::Trees->create

    # Pithub::Issues::Events->get
    # Pithub::Issues::Events->list

    # Pithub::Issues::Labels->add
    # Pithub::Issues::Labels->create
    # Pithub::Issues::Labels->delete
    # Pithub::Issues::Labels->get
    {
        my $result = $p->issues->labels->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Issues::Labels->list successful';
        eq_or_diff $result->content,
          [
            {
                'color' => 'e10c02',
                'name'  => 'Bug',
                'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Bug'
            },
            {
                'color' => '02e10c',
                'name'  => 'Feature',
                'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Feature'
            }
          ],
          'Pithub::Issues::Labels->list content';
    }

    # Pithub::Issues::Labels->list
    {
        my $result = $p->issues->labels->get( user => 'plu', repo => 'Pithub', label_id => 'Bug' );
        is $result->success, 1, 'Pithub::Issues::Labels->get successful';
        eq_or_diff $result->content,
          {
            'color' => 'e10c02',
            'name'  => 'Bug',
            'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Bug'
          },
          'Pithub::Issues::Labels->get content';
    }

    # Pithub::Issues::Labels->remove
    # Pithub::Issues::Labels->replace
    # Pithub::Issues::Labels->update

    # Pithub::Issues::Milestones->create
    # Pithub::Issues::Milestones->delete

    # Pithub::Issues::Milestones->get
    {
        my $result = $p->issues->milestones->get( user => 'plu', repo => 'Pithub', milestone_id => 1 );
        is $result->success, 1, 'Pithub::Issues::Milestones->get successful';
        is $result->content->{creator}{login}, 'plu', 'Pithub::Issues::Milestones->get: Attribute creator.login';
    }

    # Pithub::Issues::Milestones->list
    {
        my $result = $p->issues->milestones->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Issues::Milestones->list successful';
        ok $result->count > 0, 'Pithub::Issues::Milestones->list has some rows';
        is $result->content->[0]{creator}{login}, 'plu', 'Pithub::Issues::Milestones->list: Attribute creator.login';
    }

    # Pithub::Issues::Milestones->update

    # Pithub::Orgs->get
    {
        my $result = $p->orgs->get( org => 'CPAN-API' );
        is $result->success, 1, 'Pithub::Orgs->get successful';
        is $result->content->{type},  'Organization', 'Pithub::Orgs->get: Attribute type';
        is $result->content->{login}, 'CPAN-API',     'Pithub::Orgs->get: Attribute login';
        is $result->content->{name},  'CPAN API',     'Pithub::Orgs->get: Attribute name';
        is $result->content->{id},    460239,         'Pithub::Orgs->get: Attribute id';
    }

    # Pithub::Orgs->list
    {
        my $result = $p->orgs->list( user => 'plu' );
        is $result->success, 1, 'Pithub::Orgs->list successful';
        is $result->content->[0]{login}, 'CPAN-API', 'Pithub::Orgs->get: Attribute login';
        is $result->content->[0]{id},    460239,     'Pithub::Orgs->get: Attribute id';
    }

    # Pithub::Orgs->update

    # Pithub::Orgs::Members->conceal
    # Pithub::Orgs::Members->delete
    # Pithub::Orgs::Members->is_member
    # Pithub::Orgs::Members->is_public
    # Pithub::Orgs::Members->list

    # Pithub::Orgs::Members->list_public
    {
        my $result = $p->orgs->members->list_public( org => 'CPAN-API' );
        is $result->success, 1, 'Pithub::Orgs::Members->list_public successful';
        ok $result->count > 0, 'Pithub::Orgs::Members->list_public has some rows';
        while ( my $row = $result->next ) {
            ok $row->{id},    "Pithub::Orgs::Members->list_public: Attribute id ($row->{id})";
            ok $row->{login}, "Pithub::Orgs::Members->list_public: Attribute login ($row->{login})";
        }
    }

    # Pithub::Orgs::Members->publicize

    # Pithub::Orgs::Teams->add_member
    # Pithub::Orgs::Teams->add_repo
    # Pithub::Orgs::Teams->create
    # Pithub::Orgs::Teams->delete
    # Pithub::Orgs::Teams->get
    # Pithub::Orgs::Teams->get_repo
    # Pithub::Orgs::Teams->is_member
    # Pithub::Orgs::Teams->list
    # Pithub::Orgs::Teams->list_members
    # Pithub::Orgs::Teams->list_repos
    # Pithub::Orgs::Teams->remove_member
    # Pithub::Orgs::Teams->remove_repo
    # Pithub::Orgs::Teams->update

    # Pithub::PullRequests->commits
    # Pithub::PullRequests->create
    # Pithub::PullRequests->files
    # Pithub::PullRequests->get
    # Pithub::PullRequests->is_merged
    # Pithub::PullRequests->list
    # Pithub::PullRequests->merge
    # Pithub::PullRequests->update

    # Pithub::PullRequests::Comments->create
    # Pithub::PullRequests::Comments->delete
    # Pithub::PullRequests::Comments->get
    # Pithub::PullRequests::Comments->list
    # Pithub::PullRequests::Comments->update

    # Pithub::Repos->branches
    {
        my $result = $p->repos->branches( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos->branches successful';
        ok $result->count > 0, 'Pithub::Repos->branches has some rows';
        is $result->content->[0]{name}, 'master', 'Pithub::Repos->branches: Attribute name'
    }

    # Pithub::Repos->contributors
    {
        my $result = $p->repos->contributors( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos->contributors successful';
        is $result->content->[0]{login}, 'plu', 'Pithub::Repos->contributors: Attribute login'
    }

    # Pithub::Repos->get
    {
        my $result = $p->repos->get( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos->get successful';
        is $result->content->{name}, 'Pithub', 'Pithub::Repos->get: Attribute name';
        is $result->content->{owner}{login}, 'plu', 'Pithub::Repos->get: Attribute owner.login';
    }

    # Pithub::Repos->languages
    {
        my $result = $p->repos->languages( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos->languages successful';
        like $result->content->{Perl}, qr{^\d+$}, 'Pithub::Repos->languages: Attribute Perl';
    }

    # Pithub::Repos->list
    {
        my $result = $p->repos->list( user => 'plu' );
        is $result->success, 1, 'Pithub::Repos->list successful';
        ok $result->count > 0, 'Pithub::Repos->list has some rows';
        while ( my $row = $result->next ) {
            ok $row->{name}, "Pithub::Repos->list: Attribute name ($row->{name})";
        }
    }

    # Pithub::Repos->tags
    {
        my $result = $p->repos->tags( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos->tags successful';
        ok $result->count > 0, 'Pithub::Repos->tags has some rows';
        my @tags = splice @{ $result->content }, 0, 2;
        eq_or_diff \@tags,
          [
            {
                'commit' => {
                    'sha' => '1c5230f42d6d3e376162591f223fc4130d671937',
                    'url' => 'https://api.github.com/repos/plu/Pithub/commits/1c5230f42d6d3e376162591f223fc4130d671937'
                },
                'name'        => 'v0.01000',
                'tarball_url' => 'https://github.com/plu/Pithub/tarball/v0.01000',
                'zipball_url' => 'https://github.com/plu/Pithub/zipball/v0.01000'
            },
            {
                'commit' => {
                    'sha' => '09da9bff13167ca9940ff6540a7e7dcc936ca25e',
                    'url' => 'https://api.github.com/repos/plu/Pithub/commits/09da9bff13167ca9940ff6540a7e7dcc936ca25e'
                },
                'name'        => 'v0.01001',
                'tarball_url' => 'https://github.com/plu/Pithub/tarball/v0.01001',
                'zipball_url' => 'https://github.com/plu/Pithub/zipball/v0.01001'
            }
          ],
          'Pithub::Repos->tags content';
    }

    # Pithub::Repos->teams
    # Pithub::Repos->update

    # Pithub::Repos::Collaborators->add
    # Pithub::Repos::Collaborators->is_collaborator
    # Pithub::Repos::Collaborators->list
    # Pithub::Repos::Collaborators->remove

    # Pithub::Repos::Commits->create_comment
    # Pithub::Repos::Commits->delete_comment

    # Pithub::Repos::Commits->get
    {
        my $result = $p->repos->commits->get( user => 'plu', repo => 'Pithub', sha => '7e351527f62acaaeadc69acf2b80c38e48214df8' );
        is $result->success, 1, 'Pithub::Repos::Commits->get successful';
        eq_or_diff $result->content->{commit},
          {
            'author' => {
                'date'  => '2011-06-30T22:37:12-07:00',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'committer' => {
                'date'  => '2011-06-30T22:37:12-07:00',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'message' => 'Implement Pithub::Result->count.',
            'tree'    => {
                'sha' => '7e6152aa778dd2b92c0f41c4ba243ad7482d46ab',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/7e6152aa778dd2b92c0f41c4ba243ad7482d46ab'
            },
            'url' => 'https://api.github.com/repos/plu/Pithub/git/commits/7e351527f62acaaeadc69acf2b80c38e48214df8'
          },
          'Pithub::Repos::Commits->get commit content';
    }

    # Pithub::Repos::Commits->get_comment

    # Pithub::Repos::Commits->list
    {
        my $result = $p->repos->commits->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos::Commits->list successful';
        ok $result->count > 0, 'Pithub::Repos::Commits->list has some rows';
        while ( my $row = $result->next ) {
            ok $row->{sha}, "Pithub::Repos::Commits->list: Attribute sha ($row->{sha})";
        }
    }

    # Pithub::Repos::Commits->list_comments
    # Pithub::Repos::Commits->update_comment

    # Pithub::Repos::Downloads->create
    # Pithub::Repos::Downloads->delete
    # Pithub::Repos::Downloads->get
    # Pithub::Repos::Downloads->list

    # Pithub::Repos::Forks->create
    # Pithub::Repos::Forks->list

    # Pithub::Repos::Keys->create
    # Pithub::Repos::Keys->delete
    # Pithub::Repos::Keys->get
    # Pithub::Repos::Keys->list
    # Pithub::Repos::Keys->update

    # Pithub::Repos::Watching->is_watching

    # Pithub::Repos::Watching->list
    {
        my $result = $p->repos->watching->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos::Watching->list successful';
        is $result->content->[0]{id},    '31597', "Pithub::Repos::Watching->list: Attribute id";
        is $result->content->[0]{login}, 'plu',   "Pithub::Repos::Watching->list: Attribute login";
    }

    # Pithub::Repos::Watching->list_repos
    # Pithub::Repos::Watching->start_watching
    # Pithub::Repos::Watching->stop_watching

    # Pithub::Users->get
    {
        my $result = $p->users->get( user => 'plu' );
        is $result->success, 1, 'Pithub::Users->get successful';
        is $result->content->{id},    '31597',            "Pithub::Users->get: Attribute id";
        is $result->content->{login}, 'plu',              "Pithub::Users->get: Attribute login";
        is $result->content->{name},  'Johannes Plunien', "Pithub::Users->get: Attribute name";
    }

    # Pithub::Users->update

    # Pithub::Users::Emails->add
    # Pithub::Users::Emails->delete
    # Pithub::Users::Emails->list

    # Pithub::Users::Followers->follow
    # Pithub::Users::Followers->is_following
    # Pithub::Users::Followers->list
    # Pithub::Users::Followers->list_following
    # Pithub::Users::Followers->unfollow

    # Pithub::Users::Keys->create
    # Pithub::Users::Keys->delete
    # Pithub::Users::Keys->get
    # Pithub::Users::Keys->list
    # Pithub::Users::Keys->update

    # Pagination + per_page
    {
        my $g = Pithub::Gists->new( per_page => 2 );

        my @seen = ();

        my $test = sub {
            my ( $row, $seen ) = @_;
            my $verb = $seen ? 'did' : 'did not';
            my $id = $row->{id};
            ok $id, "Pithub::Gists->list found gist id ${id}";
            is grep( $_ eq $id, @seen ), $seen, "Pithub::Gists->list we ${verb} see id ${id}";
            push @seen, $id;
        };

        my $result = $g->list( public => 1 );
        is $result->success, 1, 'Pithub::Gists->list successful';
        is $result->count,   2, 'The per_page setting was successful';

        foreach my $page ( 1 .. 2 ) {
            while ( my $row = $result->next ) {
                $test->( $row, 0 );
            }
            $result = $result->next_page unless $page == 2;
        }

        # Browse to the last page and see if we can get some gist id's there
        $result = $result->last_page;
        while ( my $row = $result->next ) {
            $test->( $row, 0 );
        }

        # Browse to the previous page and see if we can get some gist id's there
        $result = $result->prev_page;
        while ( my $row = $result->next ) {
            $test->( $row, 0 );
        }

        # Browse to the first page and see if we can get some gist id's there
        $result = $result->first_page;
        while ( my $row = $result->next ) {
            $test->( $row, 1 );    # we saw those gists already!
        }
    }
}

# Following tests require a token and should only be run on a test
# account since they will cause a lot of activity in that account.
SKIP: {
    skip 'Set PITHUB_TEST_TOKEN to true to run this test', 1 unless $ENV{PITHUB_TEST_TOKEN};

    my $repo = 'Pithub-Test';
    my $user = 'pithub';
    my $p    = Pithub->new(
        user  => $user,
        repo  => $repo,
        token => $ENV{PITHUB_TEST_TOKEN}
    );

    # Pithub::Repos->create
    {
        my $result = $p->repos->create(
            data => {
                name        => $repo,
                description => 'Testing Github v3 API',
                homepage    => "http://github.com/pithub/Pithub-Test-$$",
                public      => 1,
            }
        );
        ok grep( $_ eq $result->code, qw(201 422) ), 'Pithub::Repos->create HTTP status';
    }

    {

        # Pithub::Gists->create
        my $gist_id = $p->gists->create(
            data => {
                description => 'the description for this gist',
                public      => 1,
                files       => { 'file1.txt' => { content => 'String file content' } }
            }
        )->content->{id};

        # Pithub::Gists->is_starred
        ok !$p->gists->is_starred( gist_id => $gist_id )->success, 'Pithub::Gists->is_starred not successful, gist not starred yet';

        # Pithub::Gists->star
        ok $p->gists->star( gist_id => $gist_id )->success, 'Pithub::Gists->star successful';

        # Pithub::Gists->is_starred
        ok $p->gists->is_starred( gist_id => $gist_id )->success, 'Pithub::Gists->is_starred successful, gist is starred now';

        # Pithub::Gists->unstar
        ok $p->gists->unstar( gist_id => $gist_id )->success, 'Pithub::Gists->unstar successful';

        # Pithub::Gists->is_starred
        ok !$p->gists->is_starred( gist_id => $gist_id )->success, 'Pithub::Gists->is_starred not successful, gist not starred anymore';

        # Pithub::Gists->get
        is $p->gists->get( gist_id => $gist_id )->content->{description}, 'the description for this gist', 'Pithub::Gists->get file content';

        # Pithub::Gists->update
        ok $p->gists->update(
            gist_id => $gist_id,
            data    => { description => 'the UPDATED description for this gist' }
        )->success, 'Pithub::Gists->update successful';

        # Pithub::Gists->get
        is $p->gists->get( gist_id => $gist_id )->content->{description}, 'the UPDATED description for this gist', 'Pithub::Gists->get file content';

        # Pithub::Gists::Comments->create
        my $comment_id = $p->gists->comments->create( gist_id => $gist_id, data => { body => 'some gist comment' } )->content->{id};
        like $comment_id, qr{^\d+$}, 'Pithub::Gists::Comments->create returned a comment id';

        # Pithub::Gists::Comments->get
        is $p->gists->comments->get( comment_id => $comment_id )->content->{body}, 'some gist comment', 'Pithub::Gists::Comments->get body';

        # Pithub::Gists::Comments->update
        ok $p->gists->comments->update( comment_id => $comment_id, data => { body => 'some UPDATED gist comment' } )->success,
          'Pithub::Gists::Comments->update successful';

        # Pithub::Gists::Comments->get
        is $p->gists->comments->get( comment_id => $comment_id )->content->{body}, 'some UPDATED gist comment',
          'Pithub::Gists::Comments->get body after update';

        # Pithub::Gists::Comments->delete
        ok $p->gists->comments->delete( comment_id => $comment_id )->success, 'Pithub::Gists::Comments->delete successful';

        # Pithub::Gists::Comments->get
        ok !$p->gists->comments->get( comment_id => $comment_id )->success, 'Pithub::Gists::Comments->get not successful after delete';

        # Pithub::Gists->delete
        ok $p->gists->delete( gist_id => $gist_id )->success, 'Pithub::Gists->delete successful';

        # Pithub::Gists->get
        ok !$p->gists->get( gist_id => $gist_id )->success, 'Pithub::Gists->get not successful after delete';
    }

    # Pithub::Gists->fork

    {

        # Pithub::Issues->create
        my $issue_id = $p->issues->create(
            data => {
                body  => 'Your software breaks if you do this and that',
                title => 'Found a bug',
            }
        )->content->{number};

        # Pithub::Issues->get
        is $p->issues->get( issue_id => $issue_id )->content->{title}, 'Found a bug', 'Pithub::Issues->get title attribute';

        # Pithub::Issues->update
        ok $p->issues->update(
            issue_id => $issue_id,
            data     => {
                body  => 'Your software breaks if you do this and that',
                title => 'Found a bug [UPDATED]',
            }
        )->success, 'Pithub::Issues->update successful';

        # Pithub::Issues->get
        is $p->issues->get( issue_id => $issue_id )->content->{title}, 'Found a bug [UPDATED]', 'Pithub::Issues->get updated title attribute';

        # Pithub::Issues->list
        is $p->issues->list->first->{number}, $issue_id, 'Pithub::Issues->list first item';

        # Pithub::Issues::Comments->create
        my $comment_id = $p->issues->comments->create(
            issue_id => $issue_id,
            data     => { body => 'some comment' }
        )->content->{id};

        # Pithub::Issues::Comments->get
        is $p->issues->comments->get( comment_id => $comment_id )->content->{body}, 'some comment', 'Pithub::Issues::Comments->get body attribute';

        # Pithub::Issues::Comments->list
        is $p->issues->comments->list( issue_id => $issue_id )->first->{body}, 'some comment', 'Pithub::Issues::Comments->list updated attribute';

        # Pithub::Issues::Comments->update
        ok $p->issues->comments->update(
            comment_id => $comment_id,
            data       => { body => 'some UPDATED comment' }
        )->success, 'Pithub::Issues::Comments->update successful';

        # Pithub::Issues::Comments->get
        is $p->issues->comments->get( comment_id => $comment_id )->content->{body}, 'some UPDATED comment',
          'Pithub::Issues::Comments->get updated body attribute';

        # Pithub::Issues::Comments->delete
        ok $p->issues->comments->delete( comment_id => $comment_id )->success, 'Pithub::Issues::Comments->delete successful';

        # Pithub::Issues::Comments->get
        ok !$p->issues->comments->get( comment_id => $comment_id )->success, 'Pithub::Issues::Comments->get not successful after delete';
    }
}

done_testing;
