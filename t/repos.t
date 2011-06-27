use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos');
    use_ok('Pithub::Repos::Collaborators');
    use_ok('Pithub::Repos::Commits');
    use_ok('Pithub::Repos::Downloads');
    use_ok('Pithub::Repos::Forks');
    use_ok('Pithub::Repos::Keys');
    use_ok('Pithub::Repos::Watching');
}

# Pithub::Repos->create
{
    my $obj = Pithub::Test->create('Pithub::Repos');

    isa_ok $obj, 'Pithub::Repos';

    throws_ok { $obj->create } qr{Invalid parameters}, 'No parameters';
    throws_ok { $obj->create( { foo => 1 } ) } qr{Access token required for: POST /user/repos}, 'Token required';
    throws_ok { $obj->create( foobarorg => { foo => 1 } ) } qr{Access token required for: POST /orgs/foobarorg/repos}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create( { foo => 1 } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/user/repos', 'HTTP path';
    }

    {
        my $result = $obj->create( foobarorg => { foo => 1 } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/orgs/foobarorg/repos', 'HTTP path';
    }
}

# Pithub::Repos->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos';

    {
        my $result = $obj->get;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos->list
{
    my $obj = Pithub::Test->create('Pithub::Repos');

    isa_ok $obj, 'Pithub::Repos';

    throws_ok { $obj->list } qr{Access token required for: GET /user/repos}, 'Token required';

    {
        my $result = $obj->list( user => 'plu' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/plu/repos', 'HTTP path';

        ok $result->response->parse_response( Pithub::Test->get_response('repos.list.user') ), 'Load response' if $obj->skip_request;

        is $result->code,    200, 'HTTP status';
        is $result->success, 1,   'Successful';

        is $result->content->[0]{clone_url}, 'https://github.com/plu/poe-component-irc-plugin-blowfish.git', 'Attribute exists: clone_url';
        is $result->content->[1]{clone_url}, 'https://github.com/plu/efa-wdgt-common.git', 'Attribute exists: clone_url';
        is $result->content->[0]{owner}{login}, 'plu', 'Attribute exists: owner.login';
        is $result->content->[1]{owner}{login}, 'plu', 'Attribute exists: owner.login';
    }

    {
        my $result = $obj->list( org => 'CPAN-API' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/orgs/CPAN-API/repos', 'HTTP path';

        ok $result->response->parse_response( Pithub::Test->get_response('repos.list.org') ), 'Load response' if $obj->skip_request;

        is $result->code,    200, 'HTTP status is 200';
        is $result->success, 1,   'Successful';

        is $result->content->[0]{git_url}, 'git://github.com/CPAN-API/cpan-api.git',            'Attribute exists: git_url';
        is $result->content->[1]{git_url}, 'git://github.com/CPAN-API/search-metacpan-org.git', 'Attribute exists: git_url';
        is $result->content->[0]{owner}{id}, 460239, 'Attribute exists: owner.id';
        is $result->content->[1]{owner}{id}, 460239, 'Attribute exists: owner.id';
    }

    {
        $obj->token(123);
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/repos', 'HTTP path';
    }
}

# Pithub::Repos->update
{
    my $obj = Pithub::Test->create('Pithub::Repos');

    isa_ok $obj, 'Pithub::Repos';

    throws_ok { $obj->update } qr{Missing parameter: \$name}, 'No parameters';
    throws_ok { $obj->update('bar') } qr{Missing parameter: \$data \(hashref\)}, 'Missing data';
    throws_ok { $obj->update( bar => { foo => 1 } ) } qr{Access token required for: PATCH /user/repos/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->update( foobarorg => { foo => 1 } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/user/repos/foobarorg', 'HTTP path';
    }
}

# Pithub::Repos::Collaborators->add
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Collaborators', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Collaborators';

    throws_ok { $obj->add } qr{Missing key in parameters: collaborator}, 'No parameters';
    throws_ok { $obj->add( collaborator => 'somebody' ) } qr{Access token required for: PUT /repos/foo/bar/collaborators/somebody}, 'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->add( collaborator => 'somebody' );
    is $result->request->method, 'PUT', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/collaborators/somebody', 'HTTP path';
}

# Pithub::Repos::Collaborators->is_collaborator
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Collaborators', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Collaborators';

    throws_ok { $obj->is_collaborator } qr{Missing key in parameters: collaborator}, 'No parameters';
    throws_ok { $obj->is_collaborator( collaborator => 'somebody' ) } qr{Access token required for: GET /repos/foo/bar/collaborators/somebody},
      'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->is_collaborator( collaborator => 'somebody' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/collaborators/somebody', 'HTTP path';
}

# Pithub::Repos::Collaborators->remove
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Collaborators', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Collaborators';

    throws_ok { $obj->remove } qr{Missing key in parameters: collaborator}, 'No parameters';
    throws_ok { $obj->remove( collaborator => 'somebody' ) } qr{Access token required for: DELETE /repos/foo/bar/collaborators/somebody}, 'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->remove( collaborator => 'somebody' );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/collaborators/somebody', 'HTTP path';
}

# Pithub::Repos::Commits->create_comment
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    throws_ok { $obj->create_comment } qr{Missing key in parameters: sha}, 'No parameters';
    throws_ok { $obj->create_comment( sha => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create_comment( sha => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok {
        $obj->create_comment( sha => 123, data => { foo => 'bar' } );
    }
    qr{Access token required for: POST /repos/foo/bar/commits/123/comments}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create_comment( sha => 123, data => { body => 'some comment' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/commits/123/comments', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '{"body":"some comment"}', 'HTTP body';
    }
}

# Pithub::Repos::Commits->delete_comment
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    throws_ok { $obj->delete_comment } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->delete_comment( comment_id => 123 ) } qr{Access token required for: DELETE /repos/foo/bar/comments/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete_comment( comment_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/comments/123', 'HTTP path';
    }
}

# Pithub::Repos::Commits->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    throws_ok { $obj->get } qr{Missing key in parameters: sha}, 'No parameters';

    {
        my $result = $obj->get( sha => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/commits/123', 'HTTP path';
    }
}

# Pithub::Repos::Commits->get_comment
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    throws_ok { $obj->get_comment } qr{Missing key in parameters: comment_id}, 'No parameters';

    {
        my $result = $obj->get_comment( comment_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/comments/123', 'HTTP path';
    }
}

# Pithub::Repos::Commits->list_comments
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    {
        my $result = $obj->list_comments;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/comments', 'HTTP path';
    }

    {
        my $result = $obj->list_comments( sha => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/commits/123/comments', 'HTTP path';
    }
}

# Pithub::Repos::Commits->update_comment
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    throws_ok { $obj->update_comment } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->update_comment( comment_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update_comment( comment_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok { $obj->update_comment( comment_id => 123, data => { foo => 'bar' } ) } qr{Access token required for: PATCH /repos/foo/bar/comments/123},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->update_comment( comment_id => 123, data => { body => 'some comment' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/comments/123', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '{"body":"some comment"}', 'HTTP body';
    }
}

# Pithub::Repos::Downloads->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Downloads';

    throws_ok { $obj->create } qr{not supported}, 'Not supported yet';
}

# Pithub::Repos::Downloads->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Downloads';

    throws_ok { $obj->delete } qr{Missing key in parameters: download_id}, 'No parameters';
    throws_ok { $obj->delete( download_id => 123 ) } qr{Access token required for: DELETE /repos/foo/bar/downloads/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( download_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/downloads/123', 'HTTP path';
    }
}

# Pithub::Repos::Downloads->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Downloads';

    throws_ok { $obj->get } qr{Missing key in parameters: download_id}, 'No parameters';

    {
        my $result = $obj->get( download_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/downloads/123', 'HTTP path';
    }
}

# Pithub::Repos::Forks->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Forks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Forks';

    throws_ok { $obj->create } qr{POST /repos/foo/bar/forks}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create;
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/forks', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->create( org => 'foobarorg' );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/forks', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '{"org":"foobarorg"}', 'HTTP body';
    }
}

# Pithub::Repos::Keys->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Keys', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Keys';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok {
        $obj->create( data => { title => 'some key' } );
    }
    qr{Access token required for: POST /repos/foo/bar/keys}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create( data => { title => 'some key' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/keys', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '{"title":"some key"}', 'HTTP body';
    }
}

# Pithub::Repos::Keys->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Keys', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Keys';

    throws_ok { $obj->delete } qr{Missing key in parameters: key_id}, 'No parameters';
    throws_ok { $obj->delete( key_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/keys/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( key_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/keys/123', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Keys->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Keys', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Keys';

    throws_ok { $obj->get } qr{Missing key in parameters: key_id}, 'No parameters';
    throws_ok { $obj->get( key_id => 123 ); } qr{Access token required for: GET /repos/foo/bar/keys/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->get( key_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/keys/123', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Keys->update
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Keys', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Keys';

    throws_ok { $obj->update } qr{Missing key in parameters: key_id}, 'No parameters';
    throws_ok { $obj->update( key_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok {
        $obj->update( key_id => 123, data => { title => 'some key' } );
    }
    qr{Access token required for: PATCH /repos/foo/bar/keys/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->update( key_id => 123, data => { title => 'some key' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/keys/123', 'HTTP path';
        my $http_request = $result->request->http_request;
        is $http_request->content, '{"title":"some key"}', 'HTTP body';
    }
}

done_testing;
