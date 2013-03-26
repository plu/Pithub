use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists');
    use_ok('Pithub::Gists::Comments');
}

# Pithub::Gists->create
{
    my $json = JSON->new;
    my $obj  = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';

    {
        my $result = $obj->create(
            data => {
                description => 'the description for this gist',
                public      => 1,
                files       => { 'file1.txt' => { content => 'String file content' } }
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/gists', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          { 'files' => { 'file1.txt' => { 'content' => 'String file content' } }, 'public' => 1, 'description' => 'the description for this gist' },
          'HTTP body';
    }
}

# Pithub::Gists->delete
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->delete } qr{Missing key in parameters: gist_id}, 'No parameter';
    throws_ok { $obj->delete( gist_id => 123 ) } qr{Access token required for: DELETE /gists/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( gist_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/gists/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->fork
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->fork } qr{Missing key in parameters: gist_id}, 'No parameter';

    {
        my $result = $obj->fork( gist_id => 123 );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/gists/123/forks', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->get
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->get } qr{Missing key in parameters: gist_id}, 'No parameter';

    {
        my $result = $obj->get( gist_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->is_starred
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->is_starred } qr{Missing key in parameters: gist_id}, 'No parameter';
    throws_ok { $obj->is_starred( gist_id => 123 ); } qr{Access token required for: GET /gists/123/star}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->is_starred( gist_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists/123/star', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->list
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    {
        my $result = $obj->list( user => 'foo' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/foo/gists', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        throws_ok { $obj->list( starred => 1 ) } qr{Access token required for: GET /gists/starred }, 'Token required';
        ok $obj->token(123), 'Token set';
        my $result = $obj->list( starred => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists/starred', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
        ok $obj->clear_token, 'Token removed';
    }

    {
        my $result = $obj->list( public => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists/public', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->star
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->star } qr{Missing key in parameters: gist_id}, 'No parameter';
    throws_ok { $obj->star( gist_id => 123 ) } qr{Access token required for: PUT /gists/123/star}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->star( gist_id => 123 );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/gists/123/star', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->unstar
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->unstar } qr{Missing key in parameters: gist_id}, 'No parameter';
    throws_ok { $obj->unstar( gist_id => 123 ) } qr{Access token required for: DELETE /gists/123/star}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->unstar( gist_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/gists/123/star', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists->update
{
    my $obj = Pithub::Test->create('Pithub::Gists');

    isa_ok $obj, 'Pithub::Gists';

    throws_ok { $obj->update } qr{Missing key in parameters: gist_id}, 'No parameter';
    throws_ok { $obj->update( gist_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( gist_id => 123, data => { foo => 'bar' } ) } qr{Access token required for: PATCH /gists/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->update(
            gist_id => 123,
            data    => {
                description => 'the description for this gist',
                public      => 1,
                files       => { 'file1.txt' => { content => 'String file content' } }
            }
        );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/gists/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          { 'files' => { 'file1.txt' => { 'content' => 'String file content' } }, 'public' => 1, 'description' => 'the description for this gist' },
          'HTTP body';
    }
}

# Pithub::Gists::Comments->create
{
    my $obj = Pithub::Test->create('Pithub::Gists::Comments');

    isa_ok $obj, 'Pithub::Gists::Comments';

    throws_ok { $obj->create } qr{Missing key in parameters: gist_id}, 'No parameters';
    throws_ok { $obj->create( gist_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( gist_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok { $obj->create( gist_id => 123, data => { body => 'bar' } ); } qr{Access token required for: POST /gists/123/comments}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( gist_id => 123, data => { body => 'some comment' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/gists/123/comments', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'some comment' }, 'HTTP body';
    }
}

# Pithub::Gists::Comments->delete
{
    my $obj = Pithub::Test->create('Pithub::Gists::Comments');

    isa_ok $obj, 'Pithub::Gists::Comments';

    throws_ok { $obj->delete } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->delete( comment_id => 123 ); } qr{Access token required for: DELETE /gists/comments/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( comment_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/gists/comments/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists::Comments->get
{
    my $obj = Pithub::Test->create('Pithub::Gists::Comments');

    isa_ok $obj, 'Pithub::Gists::Comments';

    throws_ok { $obj->get } qr{Missing key in parameters: comment_id}, 'No parameters';

    {
        my $result = $obj->get( comment_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists/comments/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists::Comments->list
{
    my $obj = Pithub::Test->create('Pithub::Gists::Comments');

    isa_ok $obj, 'Pithub::Gists::Comments';

    throws_ok { $obj->list } qr{Missing key in parameters: gist_id}, 'No parameters';

    {
        my $result = $obj->list( gist_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/gists/123/comments', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Gists::Comments->update
{
    my $obj = Pithub::Test->create('Pithub::Gists::Comments');

    isa_ok $obj, 'Pithub::Gists::Comments';

    throws_ok { $obj->update } qr{Missing key in parameters: comment_id}, 'No parameters';
    throws_ok { $obj->update( comment_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( comment_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok { $obj->update( comment_id => 123, data => { body => 'bar' } ); } qr{Access token required for: PATCH /gists/comments/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->update( comment_id => 123, data => { body => 'some comment' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/gists/comments/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'some comment' }, 'HTTP body';
    }
}

done_testing;
