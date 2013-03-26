use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Users');
    use_ok('Pithub::Users::Emails');
    use_ok('Pithub::Users::Followers');
    use_ok('Pithub::Users::Keys');
}

# Pithub::Users->get
{
    my $obj = Pithub::Test->create('Pithub::Users');

    isa_ok $obj, 'Pithub::Users';

    throws_ok { $obj->get } qr{Access token required for: GET /user }, 'Token required';

    {
        my $result = $obj->get( user => 'plu' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/plu', 'HTTP path';

        is $result->code,    200, 'HTTP status';
        is $result->success, 1,   'Successful';

        is $result->content->{bio},          undef,                              'Attribute exists: bio';
        is $result->content->{blog},         '',                                 'Attribute exists: blog';
        is $result->content->{company},      '',                                 'Attribute exists: company';
        is $result->content->{created_at},   '2008-10-29T09:03:04Z',             'Attribute exists: created_at';
        is $result->content->{email},        'plu@pqpq.de',                      'Attribute exists: email';
        is $result->content->{followers},    54,                                 'Attribute exists: followers';
        is $result->content->{following},    178,                                'Attribute exists: following';
        is $result->content->{html_url},     'https://github.com/plu',           'Attribute exists: html_url';
        is $result->content->{id},           31597,                              'Attribute exists: id';
        is $result->content->{location},     'Dubai',                            'Attribute exists: location';
        is $result->content->{login},        'plu',                              'Attribute exists: login';
        is $result->content->{name},         'Johannes Plunien',                 'Attribute exists: name';
        is $result->content->{public_gists}, 38,                                 'Attribute exists: public_gists';
        is $result->content->{public_repos}, 17,                                 'Attribute exists: public_repos';
        is $result->content->{type},         'User',                             'Attribute exists: type';
        is $result->content->{url},          'https://api.github.com/users/plu', 'Attribute exists: url';
    }

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->get;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user', 'HTTP path';
    }
}

# Pithub::Users->update
{
    my $obj = Pithub::Test->create('Pithub::Users');

    isa_ok $obj, 'Pithub::Users';

    throws_ok { $obj->update } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->update( data => { foo => 'bar' } ) } qr{Access token required for: PATCH /user}, 'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->update( data => { email => 'foo@bar.com' } );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/user', 'HTTP path';
}

# Pithub::Users::Emails->add
{
    my $obj = Pithub::Test->create('Pithub::Users::Emails');

    isa_ok $obj, 'Pithub::Users::Emails';

    throws_ok { $obj->add( data => 123 ) } qr{Missing key in parameters: data \(arrayref\)}, 'No parameters';
    throws_ok { $obj->add( data => ['xxx'] ) } qr{Access token required for: POST /user/emails}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->add( data => ['foo@bar.com'] );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/user/emails', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), ['foo@bar.com'], 'HTTP body';
    }

    {
        my $json = JSON->new;
        my $result = $obj->add( data => [ 'foo@bar.com', 'bar@foo.com' ] );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/user/emails', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), [ 'foo@bar.com', 'bar@foo.com' ], 'HTTP body';
    }
}

# Pithub::Users::Emails->delete
{
    my $obj = Pithub::Test->create('Pithub::Users::Emails');

    isa_ok $obj, 'Pithub::Users::Emails';

    throws_ok { $obj->delete( data => 123 ) } qr{Missing key in parameters: data \(arrayref\)}, 'No parameters';
    throws_ok { $obj->delete( data => ['xxx'] ) } qr{Access token required for: DELETE /user/emails}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->delete( data => ['foo@bar.com'] );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/user/emails', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), ['foo@bar.com'], 'HTTP body';
    }

    {
        my $json = JSON->new;
        my $result = $obj->delete( data => [ 'foo@bar.com', 'bar@foo.com' ] );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/user/emails', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), [ 'foo@bar.com', 'bar@foo.com' ], 'HTTP body';
    }
}

# Pithub::Users::Emails->list
{
    my $obj = Pithub::Test->create('Pithub::Users::Emails');

    isa_ok $obj, 'Pithub::Users::Emails';

    throws_ok { $obj->list } qr{Access token required for: GET /user/emails}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/emails', 'HTTP path';
    }
}

# Pithub::Users::Followers->follow
{
    my $obj = Pithub::Test->create('Pithub::Users::Followers');

    isa_ok $obj, 'Pithub::Users::Followers';

    throws_ok { $obj->follow } qr{Missing key in parameters: user}, 'No parameters';
    throws_ok { $obj->follow( user => 'plu' ) } qr{Access token required for: PUT /user/following/plu}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->follow( user => 'plu' );
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/user/following/plu', 'HTTP path';
    }
}

# Pithub::Users::Followers->is_following
{
    my $obj = Pithub::Test->create('Pithub::Users::Followers');

    isa_ok $obj, 'Pithub::Users::Followers';

    throws_ok { $obj->is_following } qr{Missing key in parameters: user}, 'No parameters';
    throws_ok { $obj->is_following( user => 'rafl' ) } qr{Access token required for: GET /user/following/rafl}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->is_following( user => 'rafl' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/following/rafl', 'HTTP path';

        is $result->code,        204, 'HTTP status';
        is $result->success,     1,   'Successful';
        is $result->raw_content, '',  'HTTP body is empty';
        is $result->count,       0,   'Empty HTTP body return zero';
        eq_or_diff $result->content, {}, 'Empty HTTP body generates empty hashref';
    }
}

# Pithub::Users::Followers->list
{
    my $obj = Pithub::Test->create('Pithub::Users::Followers');

    isa_ok $obj, 'Pithub::Users::Followers';

    throws_ok { $obj->list } qr{Access token required for: GET /user/followers}, 'Token required';

    {
        my $result = $obj->list( user => 'plu' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/plu/followers', 'HTTP path';
    }

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/followers', 'HTTP path';
    }
}

# Pithub::Users::Followers->list_following
{
    my $obj = Pithub::Test->create('Pithub::Users::Followers');

    isa_ok $obj, 'Pithub::Users::Followers';

    throws_ok { $obj->list_following } qr{Access token required for: GET /user/following}, 'Token required';

    {
        my $result = $obj->list_following( user => 'plu' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/plu/following', 'HTTP path';
    }

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->list_following;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/following', 'HTTP path';
    }
}

# Pithub::Users::Followers->unfollow
{
    my $obj = Pithub::Test->create('Pithub::Users::Followers');

    isa_ok $obj, 'Pithub::Users::Followers';

    throws_ok { $obj->unfollow } qr{Missing key in parameters: user}, 'No parameters';
    throws_ok { $obj->unfollow( user => 'plu' ) } qr{Access token required for: DELETE /user/following/plu}, 'Token required';

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->unfollow( user => 'plu' );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/user/following/plu', 'HTTP path';
    }
}

# Pithub::Users::Keys->create
{
    my $obj = Pithub::Test->create('Pithub::Users::Keys');

    isa_ok $obj, 'Pithub::Users::Keys';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => { foo => 'bar' } ) } qr{Access token required for: POST /user/keys}, 'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->create( data => { title => 'plu@localhost', key => 'ssh-rsa AAA...' } );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/user/keys', 'HTTP path';
}

# Pithub::Users::Keys->delete
{
    my $obj = Pithub::Test->create('Pithub::Users::Keys');

    isa_ok $obj, 'Pithub::Users::Keys';

    throws_ok { $obj->delete } qr{Missing key in parameters: key_id}, 'Token required';
    throws_ok { $obj->delete( key_id => 123 ) } qr{Access token required for: DELETE /user/keys/123}, 'Token required';

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->delete( key_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/user/keys/123', 'HTTP path';
    }
}

# Pithub::Users::Keys->get
{
    my $obj = Pithub::Test->create('Pithub::Users::Keys');

    isa_ok $obj, 'Pithub::Users::Keys';

    throws_ok { $obj->get } qr{Missing key in parameters: key_id}, 'Token required';
    throws_ok { $obj->get( key_id => 123 ) } qr{Access token required for: GET /user/keys/123}, 'Token required';

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->get( key_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/keys/123', 'HTTP path';
    }
}

# Pithub::Users::Keys->list
{
    my $obj = Pithub::Test->create('Pithub::Users::Keys');

    isa_ok $obj, 'Pithub::Users::Keys';

    throws_ok { $obj->list } qr{Access token required for: GET /user/keys}, 'Token required';

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/keys', 'HTTP path';
    }
}

# Pithub::Users::Keys->update
{
    my $obj = Pithub::Test->create('Pithub::Users::Keys');

    isa_ok $obj, 'Pithub::Users::Keys';

    throws_ok { $obj->update } qr{Missing key in parameters: key_id}, 'No parameters';
    throws_ok { $obj->update( key_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->update( key_id => 123 => data => { title => 1, key => 1 } ) } qr{Access token required for: PATCH /user/keys/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    my $result = $obj->update( key_id => 123 => data => { title => 'plu@localhost', key => 'ssh-rsa AAA...' } );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/user/keys/123', 'HTTP path';
}

done_testing;
