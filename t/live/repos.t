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
        my @sorted = sort { $a->{name} cmp $b->{name} } @{ $result->content };
        my @tags = splice @sorted, 0, 2;
        eq_or_diff \@tags,
          [
            {
                'commit' => {
                    'sha' => '1c5230f42d6d3e376162591f223fc4130d671937',
                    'url' => 'https://api.github.com/repos/plu/Pithub/commits/1c5230f42d6d3e376162591f223fc4130d671937'
                },
                'name'        => 'v0.01000',
                'tarball_url' => 'https://api.github.com/repos/plu/Pithub/tarball/v0.01000',
                'zipball_url' => 'https://api.github.com/repos/plu/Pithub/zipball/v0.01000'
            },
            {
                'commit' => {
                    'sha' => '09da9bff13167ca9940ff6540a7e7dcc936ca25e',
                    'url' => 'https://api.github.com/repos/plu/Pithub/commits/09da9bff13167ca9940ff6540a7e7dcc936ca25e'
                },
                'name'        => 'v0.01001',
                'tarball_url' => 'https://api.github.com/repos/plu/Pithub/tarball/v0.01001',
                'zipball_url' => 'https://api.github.com/repos/plu/Pithub/zipball/v0.01001'
            }
          ],
          'Pithub::Repos->tags content';
    }

    # Pithub::Repos::Commits->get
    {
        my $result = $p->repos->commits->compare( user => 'plu', repo => 'Pithub', base => 'v0.01008', head => 'master' );
        is $result->success, 1, 'Pithub::Repos::Commits->compare successful';
        is $result->content->{status}, 'ahead', 'Pithub::Repos::Commits->compare status';
        ok $result->content->{total_commits} >= 2, 'Pithub::Repos::Commits->compare total_commits';
    }

    # Pithub::Repos::Commits->get
    {
        my $result = $p->repos->commits->get( user => 'plu', repo => 'Pithub', sha => '7e351527f62acaaeadc69acf2b80c38e48214df8' );
        is $result->success, 1, 'Pithub::Repos::Commits->get successful';
        eq_or_diff $result->content->{commit},
          {
            'author' => {
                'date'  => '2011-07-01T05:37:12Z',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'comment_count' => 0,
            'committer' => {
                'date'  => '2011-07-01T05:37:12Z',
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

    # Pithub::Repos::Commits->list
    {
        my $result = $p->repos->commits->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos::Commits->list successful';
        ok $result->count > 0, 'Pithub::Repos::Commits->list has some rows';
        while ( my $row = $result->next ) {
            ok $row->{sha}, "Pithub::Repos::Commits->list: Attribute sha ($row->{sha})";
        }
    }

    # Pithub::Repos::Watching->list
    {
        my $result = $p->repos->watching->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Repos::Watching->list successful';
        like $result->content->[0]{id}, qr{^\d+$}, "Pithub::Repos::Watching->list: Attribute id";
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

    # Pithub::Repos->create
    {
        my $result = $p->repos->create(
            data => {
                name        => $repo,
                description => 'Testing Github v3 API',
                homepage    => "http://github.com/${user}/${repo}",
                public      => 1,
            }
        );
        ok grep( $_ eq $result->code, qw(201 422) ), 'Pithub::Repos->create HTTP status';
    }

    {

        # Pithub::Repos::Watching->is_watching
        ok $p->repos->watching->is_watching->success, 'Pithub::Repos::Watching->is_watching successful';

        # Pithub::Repos::Watching->is_watching
        ok !$p->repos->watching->is_watching( user => 'plu', repos => 'Pithub' )->success, 'Pithub::Repos::Watching->is_watching not successful';
    }

    {

        # Pithub::Repos::Watching->list_repos
        is $p->repos->watching->list_repos->first->{name}, $repo, 'Pithub::Repos::Watching->list_repos name';

        # Pithub::Repos::Watching->start_watching
        ok $p->repos->watching->start_watching( user => 'plu', repo => 'Pithub' )->success, 'Pithub::Repos::Watching->start_watching successful';

        # Pithub::Repos::Watching->list_repos
        is $p->repos->watching->list_repos->first->{name}, 'Pithub', 'Pithub::Repos::Watching->list_repos new watched repo';

        # Pithub::Repos::Watching->stop_watching
        ok $p->repos->watching->stop_watching( user => 'plu', repo => 'Pithub' )->success, 'Pithub::Repos::Watching->stop_watching successful';

        # Pithub::Repos::Watching->list_repos
        isnt $p->repos->watching->list_repos->content->[-1]->{name}, 'Pithub', 'Pithub::Repos::Watching->list_repos not watching anymore';
    }

    {
        require File::Basename;

        # Pithub::Repos::Downloads->create
        my $result = $p->repos->downloads->create(
            data => {
                name         => File::Basename::basename(__FILE__),
                size         => ( stat(__FILE__) )[7],
                description  => 'This test (t/live.t)',
                content_type => 'text/plain',
            },
        );
        my $id = $result->content->{id};
        ok $result->success, 'Pithub::Repos::Downloads->create successful';

        # Pithub::Repos::Downloads->upload
        ok $p->repos->downloads->upload(
            result => $result,
            file   => __FILE__,
        )->is_success, 'Pithub::Repos::Downloads->upload successful';

        # Pithub::Repos::Downloads->get
        is $p->repos->downloads->get( download_id => $id )->content->{description}, 'This test (t/live.t)', 'Pithub::Repos::Downloads->get new download';

        # Pithub::Repos::Downloads->list
        is $p->repos->downloads->list->first->{description}, 'This test (t/live.t)', 'Pithub::Repos::Downloads->list new download';

        # Pithub::Repos::Downloads->delete
        ok $p->repos->downloads->delete( download_id => $id )->success, 'Pithub::Repos::Downloads->delete successful';

        # Pithub::Repos::Downloads->get
        ok !$p->repos->downloads->get( download_id => $id )->success, 'Pithub::Repos::Downloads->get not successful after delete';
    }

    {
        # Pithub::Repos::Keys->create
        my $key_id = $p->repos->keys->create(
            data => {
                title => 'someone@somewhere',
                key   => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFkRr3GEn06UrbFEUbDFy+N0rcGyqcSVFa0FfSGXWK52143U7zTyFW0fLEhVHiD585sn8oRCOn44xfUeEHgiC6S0oto/2XELWjTO9O0nBcfxeDjvZN+8tN/w4iz0tYLOejy5FnQWJbk537TOu17v3cYgOMU1+eSLzxpxHIg3qk4dSMqdL3mI8EQ8esMu2c584BkEd6UkCNpU+3Zbq0bGzLOgKHCisvSmI0rDTtGXv3vPYyxxJ1gbRCL6MjGaGqWzJsl6cqutlhw/QCHKGnupsmiiIb58E162rg63/gugogWRi4tfmh6IlSgIx6jdTHf/20cjIcjKcyL8OFTgpA3o3V",
            }
        )->content->{id};

        # Pithub::Repos::Keys->get
        is $p->repos->keys->get( key_id => $key_id )->content->{title}, 'someone@somewhere', 'Pithub::Repos::Keys->get title attribute';

        # Pithub::Repos::Keys->list
        is $p->repos->keys->list->first->{title}, 'someone@somewhere', 'Pithub::Repos::Keys->list title attribute';

        # Pithub::Repos::Keys->update
        ok $p->repos->keys->update(
            key_id => $key_id,
            data   => { title => 'someone@somewhereelse' }
        )->success, 'Pithub::Repos::Keys->update successful';

        # Pithub::Repos::Keys->get
        is $p->repos->keys->get( key_id => $key_id )->content->{title}, 'someone@somewhereelse', 'Pithub::Repos::Keys->get title attribute after update';

        # Pithub::Repos::Keys->delete
        ok $p->repos->keys->delete( key_id => $key_id )->success, 'Pithub::Repos::Keys->delete successful';

        # Pithub::Repos::Keys->get
        ok !$p->repos->keys->get( key_id => $key_id )->success, 'Pithub::Repos::Keys->get not successful after delete';
    }

    {

        # Pithub::Repos->update
        ok $p->repos->update( repo => $repo, data => { description => "foo $$" } )->success, 'Pithub::Repos->update successful';

        # Pithub::Repos->get
        is $p->repos->get( repo => $repo )->content->{description}, "foo $$", 'Pithub::Repos->get description after update';
    }

    {

        # Pithub::Repos::Collaborators->is_collaborator
        ok !$p->repos->collaborators->is_collaborator( collaborator => 'plu' )->success, 'Pithub::Repos->Collaborators->is_collaborator not successful yet';

        # Pithub::Repos::Collaborators->add
        ok $p->repos->collaborators->add( collaborator => 'plu' )->success, 'Pithub::Repos->Collaborators->add successful';

        # Pithub::Repos::Collaborators->is_collaborator
        ok $p->repos->collaborators->is_collaborator( collaborator => 'plu' )->success, 'Pithub::Repos->Collaborators->is_collaborator successful now';

        # Pithub::Repos::Collaborators->list
        is $p->repos->collaborators->list->content->[-1]->{login}, 'plu', 'Pithub::Repos->Collaborators->list first attribute login';

        # Pithub::Repos::Collaborators->remove
        ok $p->repos->collaborators->remove( collaborator => 'plu' )->success, 'Pithub::Repos->Collaborators->remove successful now';

        # Pithub::Repos::Collaborators->is_collaborator
        ok !$p->repos->collaborators->is_collaborator( collaborator => 'plu' )->success,
          'Pithub::Repos->Collaborators->is_collaborator not successful anymore after remove';
    }

    {

        # Pithub::Repos::Commits->create_comment
        my $comment_id = $p->repos->commits->create_comment(
            sha  => '54436a6b2e335c9725f45f6562e904ad8b72d683',
            data => { body => 'some comment' },
        )->content->{id};
        like $comment_id, qr{^\d+$}, 'Pithub::Repos::Commits->create_comment returned comment id';

        # Pithub::Repos::Commits->list_comments
        is $p->repos->commits->list_comments->content->[-1]->{id}, $comment_id, 'Pithub::Repos::Commits->list_comments last comment id';

        # Pithub::Repos::Commits->update_comment
        ok $p->repos->commits->update_comment(
            comment_id => $comment_id,
            data       => { body => 'updated comment' }
        )->success, 'Pithub::Repos::Commits->update_comment successful';

        # Pithub::Repos::Commits->get_comment
        is $p->repos->commits->get_comment( comment_id => $comment_id )->content->{body}, 'updated comment', 'Pithub::Repos::Commits->get_comment after update';

        # Pithub::Repos::Commits->delete_comment
        ok $p->repos->commits->delete_comment( comment_id => $comment_id )->success, 'Pithub::Repos::Commits->delete_comment successful';

        # Pithub::Repos::Commits->get_comment
        ok !$p->repos->commits->get_comment( comment_id => $comment_id )->success, 'Pithub::Repos::Commits->get_comment not successful after delete';
    }

    {

        # Pithub::Repos::Forks->create
        my $result = $p->repos->forks->create(
            user => $org,
            repo => $org_repo,
        );
        ok grep( $_ eq $result->code, qw(201 422) ), 'Pithub::Repos::Forks->create HTTP status';

        # Pithub::Repos::Forks->list
        is $p->repos->forks->list( user => $org, repo => $org_repo )->first->{name}, 'buhtip-org-repo', 'Pithub::Repos::Forks->list after create';
    }

    {

        # Pithub::Repos::Hooks->create
        my $hook_id = $p->repos->hooks->create(
            data => {
                name   => 'irc',
                active => 1,
                config => {
                    port   => 6667,
                    room   => 'asdf',
                    server => 'irc.perl.org',
                },
            },
        )->content->{id};
        like $hook_id, qr{^\d+$}, 'Pithub::Repos::Hooks->create returned hook id';

        # Pithub::Repos::Hooks->list
        is $p->repos->hooks->list->content->[-1]->{id}, $hook_id, 'Pithub::Repos::Hooks->list last hook id';

        # Pithub::Repos::Hooks->update
        ok $p->repos->hooks->update(
            hook_id => $hook_id,
            data    => {
                config => {
                    port   => 6667,
                    room   => 'pithub',
                    server => 'irc.perl.org',
                }
            }
        )->success, 'Pithub::Repos::Hooks->update successful';

        # Pithub::Repos::Hooks->get
        is $p->repos->hooks->get( hook_id => $hook_id )->content->{config}{room}, 'pithub', 'Pithub::Repos::Hooks->get after update';

        # Pithub::Repos::Hooks->test
        is $p->repos->hooks->test( hook_id => $hook_id )->code, 204, 'Pithub::Repos::Hooks->test successful';

        # Pithub::Repos::Hooks->delete
        ok $p->repos->hooks->delete( hook_id => $hook_id )->success, 'Pithub::Repos::Hooks->delete successful';

        # Pithub::Repos::Hooks->get
        ok !$p->repos->hooks->get( hook_id => $hook_id )->success, 'Pithub::Repos::Hooks->hook_id not successful after delete';

    }
}

done_testing;
