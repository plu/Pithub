use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Pithub::Test::UA;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

my @tree = (
    {
        accessor => 'events',
        isa      => 'Pithub::Events',
        methods  => [qw(issue network org org_for_user public repos user_performed user_received)],
        subtree  => [],
    },
    {
        accessor => 'gists',
        isa      => 'Pithub::Gists',
        methods  => [qw(create delete fork get is_starred list star unstar update)],
        subtree  => [
            {
                accessor => 'comments',
                isa      => 'Pithub::Gists::Comments',
                methods  => [qw(create delete get list update)],
            },
        ],
    },
    {
        accessor => 'git_data',
        isa      => 'Pithub::GitData',
        methods  => [],
        subtree  => [
            {
                accessor => 'blobs',
                isa      => 'Pithub::GitData::Blobs',
                methods  => [qw(create get)],
            },
            {
                accessor => 'commits',
                isa      => 'Pithub::GitData::Commits',
                methods  => [qw(create get)],
            },
            {
                accessor => 'references',
                isa      => 'Pithub::GitData::References',
                methods  => [qw(create get list update)],
            },
            {
                accessor => 'tags',
                isa      => 'Pithub::GitData::Tags',
                methods  => [qw(create get)],
            },
            {
                accessor => 'trees',
                isa      => 'Pithub::GitData::Trees',
                methods  => [qw(create get)],
            },
        ],
    },
    {
        accessor => 'issues',
        isa      => 'Pithub::Issues',
        methods  => [qw(create get list update)],
        subtree  => [
            {
                accessor => 'assignees',
                isa      => 'Pithub::Issues::Assignees',
                methods  => [qw(check list)],
            },
            {
                accessor => 'comments',
                isa      => 'Pithub::Issues::Comments',
                methods  => [qw(create delete get list update)],
            },
            {
                accessor => 'events',
                isa      => 'Pithub::Issues::Events',
                methods  => [qw(get list)],
            },
            {
                accessor => 'labels',
                isa      => 'Pithub::Issues::Labels',
                methods  => [qw(add create delete get list remove replace update)],
            },
            {
                accessor => 'milestones',
                isa      => 'Pithub::Issues::Milestones',
                methods  => [qw(create delete get list update)],
            },
        ],
    },
    {
        accessor => 'orgs',
        isa      => 'Pithub::Orgs',
        methods  => [qw(get list update)],
        subtree  => [
            {
                accessor => 'members',
                isa      => 'Pithub::Orgs::Members',
                methods  => [qw(conceal delete is_member is_public list list_public publicize)],
            },
            {
                accessor => 'teams',
                isa      => 'Pithub::Orgs::Teams',
                methods  => [qw(add_member add_repo create delete get has_repo is_member list list_members list_repos remove_member remove_repo update)],
            },
        ],
    },
    {
        accessor => 'pull_requests',
        isa      => 'Pithub::PullRequests',
        methods  => [qw(commits create files get is_merged list merge update)],
        subtree  => [
            {
                accessor => 'comments',
                isa      => 'Pithub::PullRequests::Comments',
                methods  => [qw(create delete get list update)],
            },
        ],
    },
    {
        accessor => 'repos',
        isa      => 'Pithub::Repos',
        methods  => [qw(branches contributors create get languages list tags teams update)],
        subtree  => [
            {
                accessor => 'collaborators',
                isa      => 'Pithub::Repos::Collaborators',
                methods  => [qw(add is_collaborator list remove)],
            },
            {
                accessor => 'commits',
                isa      => 'Pithub::Repos::Commits',
                methods  => [qw(create_comment delete_comment get get_comment list list_comments update_comment)],
            },
            {
                accessor => 'contents',
                isa      => 'Pithub::Repos::Contents',
                methods  => [qw(archive get readme)],
            },
            {
                accessor => 'downloads',
                isa      => 'Pithub::Repos::Downloads',
                methods  => [qw(create delete get list upload)],
            },
            {
                accessor => 'forks',
                isa      => 'Pithub::Repos::Forks',
                methods  => [qw(create list)],
            },
            {
                accessor => 'hooks',
                isa      => 'Pithub::Repos::Hooks',
                methods  => [qw(create delete get list update test)],
            },
            {
                accessor => 'keys',
                isa      => 'Pithub::Repos::Keys',
                methods  => [qw(create delete get list update)],
            },
            {
                accessor => 'releases',
                isa      => 'Pithub::Repos::Releases',
                methods  => [qw(list get create update delete)],
                subtree  => [
                    {
                        accessor => 'assets',
                        isa      => 'Pithub::Repos::Releases::Assets',
                        methods  => [qw(list get create update delete)],
                    }
                ],
            },
            {
                accessor => 'starring',
                isa      => 'Pithub::Repos::Starring',
                methods  => [qw(has_starred list_repos list star unstar)],
            },
            {
                accessor => 'stats',
                isa      => 'Pithub::Repos::Stats',
                methods  => [qw(contributors)],
            },
            {
                accessor => 'statuses',
                isa      => 'Pithub::Repos::Statuses',
                methods  => [qw(create list)],
            },
            {
                accessor => 'watching',
                isa      => 'Pithub::Repos::Watching',
                methods  => [qw(is_watching list_repos list start_watching stop_watching)],
            },
        ],
    },
    {
        accessor => 'users',
        isa      => 'Pithub::Users',
        methods  => [qw(get update)],
        subtree  => [
            {
                accessor => 'emails',
                isa      => 'Pithub::Users::Emails',
                methods  => [qw(add delete list)],
            },
            {
                accessor => 'followers',
                isa      => 'Pithub::Users::Followers',
                methods  => [qw(follow is_following list list_following unfollow)],
            },
            {
                accessor => 'keys',
                isa      => 'Pithub::Users::Keys',
                methods  => [qw(create delete get list update)],
            },
        ],
    },
    {
        accessor => 'search',
        isa      => 'Pithub::Search',
        methods  => [qw(email issues repos users)],
    },
);

sub validate_tree {
    my (%args) = @_;

    my $obj   = $args{obj};
    my $tests = $args{tests};
    my $tree  = $args{tree};

    foreach my $node (@$tree) {
        my $accessor = $node->{accessor};
        $tests->( $node, $obj );
        validate_tree(
            tree  => $node->{subtree},
            obj   => $obj->$accessor,
            tests => $tests,
        ) if $node->{subtree};
    }
}

# Make sure all attributes get curried down the objects
{
    my %attributes = (
        api_uri         => 'http://foo.com',
        auto_pagination => 1,
        jsonp_callback  => 'evil',
        per_page        => 42,
        prepare_request => sub { },
        repo            => 'Pithub',
        token           => 123,
        ua              => Pithub::Test::UA->new,
        user            => 'plu',
    );

    validate_tree(
        tree  => \@tree,
        obj   => Pithub->new(%attributes),
        tests => sub {
            my ( $node, $obj ) = @_;

            my $accessor = $node->{accessor};
            my $methods  = $node->{methods};

            can_ok $obj, $accessor;
            isa_ok $obj->$accessor, $node->{isa};
            can_ok $obj->$accessor, @$methods if @{ $methods || [] };

            foreach my $attr ( keys %attributes ) {
                is $obj->$attr, $attributes{$attr}, "Attribute ${attr} was curried to ${obj}";
            }

            # the following arguments are in no way real world arguments, it's just to
            # satisfy -every- method with those arguments!
            foreach my $method (@$methods) {
                next if $node->{isa} eq 'Pithub::Repos::Downloads' and $method eq 'upload';

                my $result;
                my $data = {state => 'pending'};

                # unfortunately the API expects arrayrefs on a very few calls
                $data = []
                  if ( $node->{isa} eq 'Pithub::Users::Emails' and grep $_ eq $method, qw(add delete) )
                  or ( $node->{isa} eq 'Pithub::Issues::Labels' and grep $_ eq $method, qw(add replace) );

                lives_ok {
                    $result = $obj->$accessor->$method(
                        archive_format => 'tarball',
                        asset_id       => 1,
                        assignee       => 'john',
                        collaborator   => 1,
                        comment_id     => 1,
                        content_type   => 'text/plain',
                        data           => $data,
                        download_id    => 1,
                        email          => 'foo',
                        event_id       => 1,
                        gist_id        => 1,
                        hook_id        => 1,
                        issue_id       => 1,
                        key_id         => 1,
                        keyword        => 'foo',
                        label          => 1,
                        milestone_id   => 1,
                        name           => 'foo',
                        options        => {
                            prepare_request => sub {
                                shift->header( 'Accept' => 'foo.bar' );
                            },
                        },
                        org             => 1,
                        pull_request_id => 1,
                        ref             => 1,
                        release_id      => 1,
                        repo            => 1,
                        sha             => 1,
                        state           => 'open',
                        team_id         => 1,
                        user            => 1,
                    );
                }
                "Calling $node->{isa}->$method with pseudo arguments";

                is $result->request->header('Accept'), 'foo.bar', "$node->{isa}->$method options prepare_request set";
            }
        }
    );

    validate_tree(
        tree  => \@tree,
        obj   => Pithub->new,
        tests => sub {
            my ( $node, $obj ) = @_;
            foreach my $attr ( keys %attributes ) {
                isnt $obj->$attr, $attributes{$attr}, "Attribute ${attr} was not curried to ${obj}";
            }
        }
    );
}

{
    my $p = Pithub::Test->create('Pithub');

    isa_ok $p, 'Pithub';

    throws_ok { $p->request } qr{Missing mandatory key in parameters: method}, 'Not given any parameters';
    throws_ok { $p->request( method => 'GET' ) } qr{Missing mandatory key in parameters: path}, 'Parameter path missing';
    throws_ok { $p->request( method => 'xxx', path => '/bar' ) } qr{Invalid method: xxx}, 'Not a valid HTTP method';
    lives_ok { $p->request( method => 'GET', path => 'bar' ) } 'Correct parameters do not throw an exception';

    throws_ok { $p->request( method => 'GET', path => '/bar', options => [] ) }
    qr{The key options must be a hashref},
      'options must be a hashref';

    throws_ok { $p->request( method => 'GET', path => '/bar', options => { prepare_request => 1 } ) }
    qr{The key prepare_request in the options hashref must be a coderef},
      'prepare_request must be a coderef';

    lives_ok { $p->request( method => 'GET', path => 'bar', options => {} ) } 'Empty options hashref';

    my $result       = $p->request( method => 'GET', path => '/bar' );
    my $response     = $result->response;
    my $http_request = $response->request;

    isa_ok $result,       'Pithub::Result';
    isa_ok $response,     'HTTP::Response';
    isa_ok $http_request, 'HTTP::Request';

    is $http_request->content, '', 'The data hashref is undef';

    is $http_request->uri->path, '/bar', 'The HTTP path was set in the HTTP::Request object';
    is $http_request->header('Authorization'), undef, 'Authorization header was not set in the HTTP::Request object';

    is $http_request->header('Content-Length'), 0, 'Content-Length header was set';
}

{
    my $json = JSON->new;
    my $p    = Pithub::Test->create('Pithub');
    $p->token('123');
    my $request = $p->request( method => 'POST', path => '/foo', data => { some => 'data' } )->request;
    eq_or_diff $json->decode( $request->content ), { some => 'data' }, 'The JSON content was set in the request object';
    is $request->header('Authorization'), 'token 123', 'Authorization header was set in the HTTP::Request object';
    ok $p->clear_token, 'Access token clearer';
    is $p->token, undef, 'No token set anymore';
    $request = $p->request( method => 'POST', path => '/foo', data => { some => 'data' } )->request;
    is $request->header('Authorization'), undef, 'Authorization header was not set in the HTTP::Request object';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->request( method => 'GET', path => '/error/notfound' );

    is $result->code,    404, 'HTTP status is 404';
    is $result->success, '',  'Unsuccessful response';

    ok $result->raw_content, 'Has raw JSON content';
    is ref( $result->content ), 'HASH', 'Has decoded JSON hashref';

    is $result->content->{message}, 'Not Found', 'Attribute exists in response: message';

    is $result->ratelimit,           5000, 'Accessor to X-RateLimit-Limit header';
    is $result->ratelimit_remaining, 4962, 'Accessor to X-RateLimit-Remaining header';

    is $result->count, 0, 'Count accessor';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->users->followers->list( user => 'miyagawa' );

    is $result->count,          30,                                                        'Count accessor';
    is $result->first_page_uri, undef,                                                     'First page link on first page';
    is $result->prev_page_uri,  undef,                                                     'First page link on first page';
    is $result->next_page_uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'Next page link on first page';
    is $result->last_page_uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page link on first page';

    is $result->first_page, undef, 'We are on first page already';
    is $result->prev_page,  undef, 'No prev page on the first page';
    is $result->next_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=2',  'Next page call';
    is $result->last_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=26', 'Last page call';

    is $result->get_page(42)->request->uri, 'https://api.github.com/users/miyagawa/followers?page=42',
      'URI for get_page is generated, no matter if it exists or not';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->users->followers->list( user => 'miyagawa' )->get_page(3);

    is $result->first_page_uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page link on third page';
    is $result->prev_page_uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'First page link no third page';
    is $result->next_page_uri,  'https://api.github.com/users/miyagawa/followers?page=4',  'Next page link no third page';
    is $result->last_page_uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page link no third page';

    is $result->first_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page call';
    is $result->prev_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'Prev page call';
    is $result->next_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=4',  'Next page call';
    is $result->last_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page call';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->users->followers->list( user => 'miyagawa' )->get_page(26);

    is $result->first_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page call';
    is $result->prev_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=25', 'Prev page call';
    is $result->next_page, undef, 'No next page on the last page';
    is $result->last_page, undef, 'We are on last page already';

    is $result->get_page(42)->request->uri, 'https://api.github.com/users/miyagawa/followers?page=42',
      'URI for get_page is generated, no matter if it exists or not';
}

{
    my $p = Pithub::Test->create( 'Pithub', per_page => 1 );
    my $result = $p->users->followers->list( user => 'miyagawa' );

    eq_or_diff { $result->next_page->request->uri->query_form }, { page => 2,   per_page => 1 }, 'Next page call';
    eq_or_diff { $result->last_page->request->uri->query_form }, { page => 769, per_page => 1 }, 'Last page call';
    is $result->prev_page,  undef, 'No prev page on the first page';
    is $result->first_page, undef, 'We are on first page already';

    eq_or_diff { $result->get_page(42)->request->uri->query_form }, { page => 42, per_page => 1 },
      'URI for get_page is generated, no matter if it exists or not';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->users->get( user => 'plu' );

    is $result->first_page, undef, 'First page call';
    is $result->prev_page,  undef, 'Prev page call';
    is $result->next_page,  undef, 'No next page on the last page';
    is $result->last_page,  undef, 'We are on last page already';

    is $result->get_page(1), undef, 'No page 1';
    is $result->count, 1, 'Count accessor';
}

{
    my $p = Pithub::Test->create( 'Pithub', jsonp_callback => 'foo' );
    my $result = $p->request( method => 'GET', path => '/foo' );
    is $result->request->uri->query, 'callback=foo', 'The callback parameter was set';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->request( method => 'GET', path => '/orgs/CPAN-API/repos' );

    my @expectations = (
        'https://github.com/CPAN-API/cpan-api',        'https://github.com/CPAN-API/search-metacpan-org',
        'https://github.com/CPAN-API/cpanvote-server', 'https://github.com/CPAN-API/cpanvote-db',
        'https://github.com/CPAN-API/metacpan-web',
    );

    is $result->first->{html_url}, $expectations[0], 'Accesor first on an arrayref content';

    while ( my $row = $result->next ) {
        is $row->{html_url}, shift(@expectations), 'Iterator next';
    }

    is scalar(@expectations), 0, 'Consumed all rows';
}

{
    my $p = Pithub::Test->create('Pithub');
    my $result = $p->request( method => 'GET', path => '/users/plu' );

    my $row = $result->next;
    is $row->{id}, 31597, 'Row data found';

    eq_or_diff $result->first, $row, 'Accessor first on a hashref content';

    is $result->next, undef, 'There is only one record';
}

{
    my $p = Pithub::Test->create( 'Pithub', per_page => 15 );
    my $result = $p->users->followers->list( user => 'plu' );
    $result->auto_pagination(1);
    my @followers = ();
    while ( my $row = $result->next ) {
        push @followers, $row;
    }
    is scalar(@followers), 54, 'Automatically paginate through four pages';
}

{
    my $p = Pithub::Test->create( 'Pithub', per_page => 15, auto_pagination => 1 );
    my $result = $p->users->followers->list( user => 'plu' );
    my @followers = ();
    while ( my $row = $result->next ) {
        push @followers, $row;
    }
    is scalar(@followers), 54, 'Automatically paginate through four pages';
}

{
    my $p = Pithub::Test->create(
        'Pithub',
        prepare_request => sub {
            my ($request) = @_;
            $request->header( Accept => 'anything' );
        }
    );
    my $result = $p->users->followers->list( user => 'plu' );
    is $result->request->header('Accept'), 'anything', 'The request header got set using global prepare_request';
}

{
    my $p      = Pithub::Test->create('Pithub');
    my $result = $p->users->followers->list(
        user    => 'plu',
        options => {
            prepare_request => sub {
                my ($request) = @_;
                $request->header( Accept => 'foobar' );
              }
        }
    );
    is $result->request->header('Accept'), 'foobar', 'The request header got set via the method call';
}

{
    my $p = Pithub::Test->create('Pithub');
    throws_ok {
        $p->users->get( user => 'foo', params => 5 );
    }
    qr{The key params must be a hashref}, 'The params key must be a hashref';

    my $result = $p->users->get( user => 'foo', params => { direction => 'asc' } );
    my %query = $result->request->uri->query_form;
    eq_or_diff \%query, { direction => 'asc' }, 'The params were set';
}

done_testing;
