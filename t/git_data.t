use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::GitData::Blobs');
    use_ok('Pithub::GitData::Commits');
    use_ok('Pithub::GitData::References');
    use_ok('Pithub::GitData::Tags');
    use_ok('Pithub::GitData::Trees');
}

# Pithub::GitData::Blobs->create
{
    my $json = JSON->new;
    my $obj = Pithub::Test->create( 'Pithub::GitData::Blobs', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Blobs';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { content => 123 } ); } qr{Access token required for: POST /repos/foo/bar/git/blobs}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create(
            data => {
                content  => 'Content of the blob',
                encoding => 'utf-8',
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/blobs', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'content' => 'Content of the blob', 'encoding' => 'utf-8' }, 'HTTP body';
    }
}

# Pithub::GitData::Blobs->get
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Blobs', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Blobs';

    throws_ok { $obj->get } qr{Missing key in parameters: sha}, 'No parameters';

    {
        my $result = $obj->get( sha => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/blobs/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::GitData::Commits->create
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Commits';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { content => 123 } ); } qr{Access token required for: POST /repos/foo/bar/git/commits}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( data => { message => 'my commit message' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/commits', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'message' => 'my commit message' }, 'HTTP body';
    }
}

# Pithub::GitData::Commits->get
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Commits';

    throws_ok { $obj->get } qr{Missing key in parameters: sha}, 'No parameters';

    {
        my $result = $obj->get( sha => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/commits/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::GitData::References->get
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::References', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::References';

    throws_ok { $obj->get } qr{Missing key in parameters: ref}, 'No parameters';

    {
        my $result = $obj->get( ref => 'heads/sc/featureA' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/refs/heads/sc/featureA', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::GitData::References->create
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::References', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::References';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { ref => 'refs/heads/master' } ); } qr{Access token required for: POST /repos/foo/bar/git/refs}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( data => { ref => 'refs/heads/master' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/refs', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'ref' => 'refs/heads/master' }, 'HTTP body';
    }
}

# Pithub::GitData::References->list
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::References', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::References';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/refs', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->list( ref => 'tags' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/refs/tags', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::GitData::References->update
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::References', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::References';

    throws_ok { $obj->update } qr{Missing key in parameters: ref}, 'No parameters';
    throws_ok { $obj->update( ref => 'foo/bar' ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( ref => 'foo/bar', data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( ref => 'foo/bar', data => { sha => 123 } ); } qr{Access token required for: PATCH /repos/foo/bar/git/refs}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->update( ref => 'foo/bar', data => { sha => '123' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/refs/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'sha' => '123' }, 'HTTP body';
    }
}

# Pithub::GitData::Tags->get
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Tags', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Tags';

    throws_ok { $obj->get } qr{Missing key in parameters: sha}, 'No parameters';

    {
        my $result = $obj->get( sha => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/tags/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::GitData::Tags->create
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Tags', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Tags';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { bla => 'fasel' } ); } qr{Access token required for: POST /repos/foo/bar/git/tags}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json   = JSON->new;
        my $result = $obj->create(
            data => {
                message => 'Tagged v0.1',
                object  => '827efc6d56897b048c772eb4087f854f46256132',
                tag     => 'v0.1',
                type    => 'commit',
            }
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/tags', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ),
          { 'object' => '827efc6d56897b048c772eb4087f854f46256132', 'type' => 'commit', 'tag' => 'v0.1', 'message' => 'Tagged v0.1' }, 'HTTP body';
    }
}

# Pithub::GitData::Trees->get
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Trees', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Trees';

    throws_ok { $obj->get } qr{Missing key in parameters: sha}, 'No parameters';

    {
        my $result = $obj->get( sha => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/trees/123', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $result = $obj->get( sha => 456, recursive => 1 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/trees/456', 'HTTP path';
        is $result->request->uri->query, 'recursive=1', 'HTTP GET parameters';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::GitData::Trees->create
{
    my $obj = Pithub::Test->create( 'Pithub::GitData::Trees', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::GitData::Trees';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { tree => [ { path => 'file1.pl' } ] } ); } qr{Access token required for: POST /repos/foo/bar/git/trees},
      'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( data => { tree => [ { path => 'file1.pl' } ] } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/git/trees', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'tree' => [ { 'path' => 'file1.pl' } ] }, 'HTTP body';
    }
}

done_testing;
