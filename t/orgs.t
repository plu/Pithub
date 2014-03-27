use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Test::Most;
use MIME::Base64 qw();

BEGIN {
    use_ok('Pithub::Orgs');
    use_ok('Pithub::Orgs::Members');
    use_ok('Pithub::Orgs::Teams');
}

# Pithub::Orgs->get
{
    my $obj = Pithub::Test->create( 'Pithub::Orgs', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Orgs';

    throws_ok { $obj->get } qr{Missing key in parameters: org}, 'No parameters';

    {
        my $result = $obj->get( org => 'some-org' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/some-org', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs->list
{
    my $obj = Pithub::Test->create( 'Pithub::Orgs', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Orgs';

    {
        my $result = $obj->list( user => 'foo' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/foo/orgs', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        throws_ok { $obj->list } qr{Access token required for: GET /user/orgs}, 'Token required';
        ok $obj->token(123), 'Token set';
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/orgs', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
    {
        # Check if prepare_request is able to add a authorization header to
        # satisfy has_token
        $obj->clear_token;
        throws_ok { $obj->list } qr{Access token required for: GET /user/orgs}, 'Token required';
        $obj->prepare_request(sub {
                my $req = shift;
                $req->header(
                    'Authorization' => 'Basic ' . MIME::Base64::encode(
                        'someuser:sometoken'
                    )
                );
            }
        );
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/orgs', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }


}

# Pithub::Orgs->update
{
    my $obj = Pithub::Test->create( 'Pithub::Orgs', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Orgs';

    throws_ok { $obj->update } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->update( org => 'bla' ) } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->update( org => 'bla', data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( org => 'bla', data => { foo => 123 } ); } qr{Access token required for: PATCH /orgs/bla}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            org  => 'some-org',
            data => {
                billing_email => 'support@github.com',
                blog          => 'https://github.com/blog',
                company       => 'GitHub',
                email         => 'support@github.com',
                location      => 'San Francisco',
                name          => 'github',
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/orgs/some-org', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          {
            'email'         => 'support@github.com',
            'location'      => 'San Francisco',
            'billing_email' => 'support@github.com',
            'name'          => 'github',
            'blog'          => 'https://github.com/blog',
            'company'       => 'GitHub'
          },
          'HTTP body';
    }
}

# Pithub::Orgs::Members->conceal
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Members');

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->conceal } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->conceal( org => 'foo-org' ) } qr{Missing key in parameters: user}, 'No user parameter';
    throws_ok { $obj->conceal( org => 'foo', user => 'bar' ); } qr{Access token required for: DELETE /orgs/foo/public_members/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->conceal( org => 'foo', user => 'bar' );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/public_members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Members->delete
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Members');

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->delete } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->delete( org => 'foo-org' ) } qr{Missing key in parameters: user}, 'No user parameter';
    throws_ok { $obj->delete( org => 'foo', user => 'bar' ); } qr{Access token required for: DELETE /orgs/foo/members/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( org => 'foo', user => 'bar' );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Members->is_member
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Members');

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->is_member } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->is_member( org => 'foo-org' ) } qr{Missing key in parameters: user}, 'No user parameter';
    throws_ok { $obj->is_member( org => 'foo', user => 'bar' ); } qr{Access token required for: GET /orgs/foo/members/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->is_member( org => 'foo', user => 'bar' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Members->is_public
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Members');

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->is_public } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->is_public( org => 'foo-org' ) } qr{Missing key in parameters: user}, 'No user parameter';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->is_public( org => 'foo', user => 'bar' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/public_members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Members->list
{
    my $obj = Pithub::Test->create( 'Pithub::Orgs::Members', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->list } qr{Missing key in parameters: org}, 'No parameters';

    {
        my $result = $obj->list( org => 'foo' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/members', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Members->list_public
{
    my $obj = Pithub::Test->create( 'Pithub::Orgs::Members', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->list_public } qr{Missing key in parameters: org}, 'No parameters';

    {
        my $result = $obj->list_public( org => 'foo' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/public_members', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Members->publicize
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Members');

    isa_ok $obj, 'Pithub::Orgs::Members';

    throws_ok { $obj->publicize } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->publicize( org => 'foo-org' ) } qr{Missing key in parameters: user}, 'No user parameter';
    throws_ok { $obj->publicize( org => 'foo', user => 'bar' ); } qr{Access token required for: PUT /orgs/foo/public_members/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->publicize( org => 'foo', user => 'bar' );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/orgs/foo/public_members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->add_member
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->add_member } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->add_member( team_id => 123 ) } qr{Missing key in parameters: user}, 'No user parameter';
    throws_ok { $obj->add_member( team_id => 123, user => 'bar' ); } qr{Access token required for: PUT /teams/123/members/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->add_member( team_id => 123, user => 'bar' );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/teams/123/members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->add_repo
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->add_repo } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->add_repo( team_id => 123 ) } qr{Missing key in parameters: repo}, 'No repo parameter';
    throws_ok { $obj->add_repo( team_id => 123, repo => 'bar' ); } qr{Missing key in parameters: org}, 'No org paramter';
    throws_ok { $obj->add_repo( team_id => 123, repo => 'bar', org => 'myorg'); } qr{Access token required for: PUT /teams/123/repos/myorg/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->add_repo( team_id => 123, repo => 'bar', org => 'myorg' );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/teams/123/repos/myorg/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->create
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->create } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->create( org => 'blorg', data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( org => 'blorg', data => { foo => 1 } ); } qr{Access token required for: POST /orgs/blorg/teams\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            org  => 'blorg',
            data => {
                name       => 'new team',
                permission => 'push',
                repo_names => ['github/dotfiles']
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/orgs/blorg/teams', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'permission' => 'push', 'name' => 'new team', 'repo_names' => ['github/dotfiles'] },
          'HTTP body';
    }
}

# Pithub::Orgs::Teams->delete
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->delete } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->delete( team_id => 123 ); } qr{Access token required for: DELETE /teams/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( team_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/teams/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->get
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->get } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->get( team_id => 123 ); } qr{Access token required for: GET /teams/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->get( team_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/teams/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->has_repo
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->has_repo } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->has_repo( team_id => 123 ) } qr{Missing key in parameters: repo}, 'No parameters';
    throws_ok { $obj->has_repo( team_id => 123, repo => 'foo' ); } qr{Access token required for: GET /teams/123/repos/foo\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->has_repo( team_id => 123, repo => 'foo' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/teams/123/repos/foo', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->is_member
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->is_member } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->is_member( team_id => 123 ) } qr{Missing key in parameters: user}, 'No parameters';
    throws_ok { $obj->is_member( team_id => 123, user => 'foo' ); } qr{Access token required for: GET /teams/123/members/foo\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->is_member( team_id => 123, user => 'foo' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/teams/123/members/foo', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->list
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->list } qr{Missing key in parameters: org}, 'No parameters';
    throws_ok { $obj->list( org => 'foorg' ); } qr{Access token required for: GET /orgs/foorg/teams\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->list( org => 'foorg' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/foorg/teams', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->list_members
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->list_members } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->list_members( team_id => 123 ); } qr{Access token required for: GET /teams/123/members\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->list_members( team_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/teams/123/members', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->list_repos
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->list_repos } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->list_repos( team_id => 123 ); } qr{Access token required for: GET /teams/123/repos\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->list_repos( team_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/teams/123/repos', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->remove_member
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->remove_member } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->remove_member( team_id => 123 ) } qr{Missing key in parameters: user}, 'No user parameter';
    throws_ok { $obj->remove_member( team_id => 123, user => 'bar' ); } qr{Access token required for: DELETE /teams/123/members/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->remove_member( team_id => 123, user => 'bar' );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/teams/123/members/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->remove_repo
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->remove_repo } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->remove_repo( team_id => 123 ) } qr{Missing key in parameters: repo}, 'No repo parameter';
    throws_ok { $obj->remove_repo( team_id => 123, repo => 'bar' ); } qr{Access token required for: DELETE /teams/123/repos/bar\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->remove_repo( team_id => 123, repo => 'bar' );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/teams/123/repos/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Orgs::Teams->update
{
    my $obj = Pithub::Test->create('Pithub::Orgs::Teams');

    isa_ok $obj, 'Pithub::Orgs::Teams';

    throws_ok { $obj->update } qr{Missing key in parameters: team_id}, 'No parameters';
    throws_ok { $obj->update( team_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( team_id => 123, data => { foo => 1 } ); } qr{Access token required for: PATCH /teams/123\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            team_id => 123,
            data    => {
                name       => 'new team name',
                permission => 'push',
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/teams/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'permission' => 'push', 'name' => 'new team name' }, 'HTTP body';
    }
}

done_testing;
