use FindBin;
use lib "$FindBin::Bin/lib";
use JSON;
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos');
    use_ok('Pithub::Repos::Collaborators');
    use_ok('Pithub::Repos::Commits');
    use_ok('Pithub::Repos::Downloads');
    use_ok('Pithub::Repos::Forks');
    use_ok('Pithub::Repos::Hooks');
    use_ok('Pithub::Repos::Keys');
    use_ok('Pithub::Repos::Releases');
    use_ok('Pithub::Repos::Releases::Assets');
    use_ok('Pithub::Repos::Starring');
    use_ok('Pithub::Repos::Stats');
    use_ok('Pithub::Repos::Statuses');
    use_ok('Pithub::Repos::Watching');
}

# Pithub::Repos->create
{
    my $obj = Pithub::Test->create('Pithub::Repos');

    isa_ok $obj, 'Pithub::Repos';

    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->create( data => { foo => 1 } ) } qr{Access token required for: POST /user/repos}, 'Token required';
    throws_ok { $obj->create( org => 'foo', data => { foo => 1 } ) } qr{Access token required for: POST /orgs/foo/repos}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( data => { foo => 1 } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/user/repos', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'foo' => 1 }, 'HTTP body';
    }

    {
        my $json = JSON->new;
        my $result = $obj->create( org => 'foobarorg', data => { bar => 1 } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/orgs/foobarorg/repos', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'bar' => 1 }, 'HTTP body';
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
        my $http_request = $result->request;
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
    my $obj = Pithub::Test->create( 'Pithub::Repos', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos';

    throws_ok { $obj->update( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
    throws_ok { $obj->update( data => { foo => 1 } ) } qr{Access token required for: PATCH /repos/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->update( user => 'bla', repo => 'fasel', data => { foo => 1 } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/bla/fasel', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'foo' => 1 }, 'HTTP body';
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

# Pithub::Repos::Commits->compare
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Commits', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Commits';

    throws_ok { $obj->compare } qr{Missing key in parameters: base}, 'No parameters';
    throws_ok { $obj->compare( base => 'from' ) } qr{Missing key in parameters: head}, 'Not enough parameters';

    {
        my $result = $obj->compare( base => 'from', head => 'to' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/compare/from...to', 'HTTP path';
    }
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
        my $json = JSON->new;
        my $result = $obj->create_comment( sha => 123, data => { body => 'some comment' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/commits/123/comments', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'some comment' }, 'HTTP body';
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
        my $json = JSON->new;
        my $result = $obj->update_comment( comment_id => 123, data => { body => 'some comment' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/comments/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'body' => 'some comment' }, 'HTTP body';
    }
}

# Pithub::Repos::Contents->archive
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Contents', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Contents';

    throws_ok { $obj->archive } qr{Missing key in parameters: archive_format}, 'No parameters';
    throws_ok { $obj->archive( archive_format => 'foo' ) } qr{Invalid archive_format. Valid formats: tarball, zipball}, 'No parameters';

    for my $format (qw(tarball zipball)) {
        my $result = $obj->archive( archive_format => $format );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, "/repos/foo/bar/$format", 'HTTP path';
    }
}

# Pithub::Repos::Contents->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Contents', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Contents';

    {
        my $result = $obj->get( params => { ref => 'bla' } );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/contents', 'HTTP path';
        is $result->request->uri->query, 'ref=bla', 'HTTP query params';
    }

    {
        my $result = $obj->get( path => 'bla/fasel/file.pm', params => { ref => 'bla' } );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/contents/bla/fasel/file.pm', 'HTTP path';
        is $result->request->uri->query, 'ref=bla', 'HTTP query params';
    }
}

# Pithub::Repos::Contents->readme
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Contents', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Contents';

    {
        my $result = $obj->readme( params => { ref => 'bla' } );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/readme', 'HTTP path';
        is $result->request->uri->query, 'ref=bla', 'HTTP query params';
    }
}

# Pithub::Repos::Downloads->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Downloads';

    throws_ok { $obj->create( data => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
    throws_ok { $obj->create( data => { foo => 'bar' } ) } qr{Access token required for: POST /repos/foo/bar/downloads\s+}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create(
            user => 'foo',
            repo => 'bar',
            data => {
                name         => 'new_file.jpg',
                size         => 114034,
                description  => 'Latest release',
                content_type => 'text/plain',
            },
        );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/downloads', 'HTTP path';
    }
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

# Pithub::Repos::Downloads->upload
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Downloads';

    ok $obj->token(123), 'Token set';

    my $result = $obj->create(
        user => 'foo',
        repo => 'bar',
        data => {
            name         => 'new_file.jpg',
            size         => 114034,
            description  => 'Latest release',
            content_type => 'text/plain',
        },
    );

    throws_ok { $obj->upload( result => 123 ) } qr{Missing key in parameters: result \(Pithub::Result object\)}, 'No parameters';
    throws_ok { $obj->upload( result => $result ) } qr{Missing key in parameters: file}, 'No file parameter';

    my $response = $obj->upload( result => $result, file => __FILE__ );
    my $request = $response->request;

    isa_ok $response, 'HTTP::Response';
    isa_ok $request,  'HTTP::Request';

    is $request->uri, 'https://github.s3.amazonaws.com/', 'Amazon S3 API URI';
    is $request->method, 'POST', 'HTTP method for Amazon S3 API call';

    delete $result->content->{path};
    throws_ok { $obj->upload( result => $result, file => __FILE__ ) } qr{Missing key in Pithub::Result content: path}, 'Missing key in Pithub::Result';
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
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        my $json = JSON->new;
        my $result = $obj->create( org => 'foobarorg' );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/forks', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'org' => 'foobarorg' }, 'HTTP body';
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
        my $json = JSON->new;
        my $result = $obj->create( data => { title => 'some key' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/keys', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'title' => 'some key' }, 'HTTP body';
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
        my $http_request = $result->request;
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
        my $http_request = $result->request;
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
        my $json = JSON->new;
        my $result = $obj->update( key_id => 123, data => { title => 'some key' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/keys/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'title' => 'some key' }, 'HTTP body';
    }
}

# Pithub::Repos::Releases->list
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases';

    {
        my $result = $obj->list;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Releases->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases';

    throws_ok { $obj->get } qr{Missing key in parameters: release_id}, 'No parameters';

    {
        my $result = $obj->get( release_id => 1 ) ;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/1', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Releases->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( data => { foo => 'bar' } ); } qr{Access token required for: POST /repos/foo/bar/releases}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create( data => { tag_name => 'foo' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases', 'HTTP path';
        my $http_request = $result->request;
        my $json   = JSON->new;
        eq_or_diff $json->decode( $http_request->content ), { tag_name => 'foo' }, 'HTTP body';
    }
}

# Pithub::Repos::Releases->update
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases';

    throws_ok { $obj->update } qr{Missing key in parameters: release_id}, 'No parameters';
    throws_ok { $obj->update( release_id => 1 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( release_id => 1, data => { foo => 'bar' } ); } qr{Access token required for: PATCH /repos/foo/bar/releases/1}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->update( release_id => 1, data => { tag_name => 'foo' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/1', 'HTTP path';
        my $http_request = $result->request;
        my $json   = JSON->new;
        eq_or_diff $json->decode( $http_request->content ), { tag_name => 'foo' }, 'HTTP body';
    }
}

# Pithub::Repos::Releases->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases';

    throws_ok { $obj->delete } qr{Missing key in parameters: release_id}, 'No parameters';
    throws_ok { $obj->delete( release_id => 1 ); } qr{Access token required for: DELETE /repos/foo/bar/releases/1}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( release_id => 1 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/1', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Releases::Assets->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases::Assets', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases::Assets';
    throws_ok { $obj->create } qr{Missing key in parameters: name}, 'No parameters';
    throws_ok { $obj->create(name => 'foo') } qr{Missing key in parameters: release_id}, 'No release_id parameter';
    throws_ok { $obj->create(name => 'foo', release_id => 1) } qr{Missing key in parameters: data}, 'No data parameter';
    throws_ok { $obj->create(name => 'foo', release_id => 1, data => 'data') } qr{Missing key in parameters: content_type}, 'No content_type parameter';
    throws_ok { $obj->create(name => 'foo', release_id => 1, data => 'data', content_type => 'text/plain') } qr{Access token required for: POST /repos/foo/bar/releases/1/assets}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->create( release_id => 1, name => 'foo', data => 'data', content_type => 'text/plain' );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/1/assets', 'HTTP path';
        is $result->request->uri->host, 'uploads.github.com', 'HTTP host';
        is $result->request->uri->query, 'name=foo', 'HTTP query';
        is $result->request->content, 'data', 'HTTP body';
        is $result->request->header('Content-Type'), 'text/plain', 'HTTP content type header';
    }
}

# Pithub::Repos::Releases::Assets->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases::Assets', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases::Assets';
    throws_ok { $obj->delete } qr{Missing key in parameters: asset_id}, 'No parameters';
    throws_ok { $obj->delete( asset_id => 1 ); } qr{Access token required for: DELETE /repos/foo/bar/releases/assets/1}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( asset_id => 1 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/assets/1', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Releases::Assets->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases::Assets', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases::Assets';
    throws_ok { $obj->get } qr{Missing key in parameters: asset_id}, 'No parameters';

    isa_ok $obj, 'Pithub::Repos::Releases::Assets';

    {
        my $result = $obj->get( asset_id => 51 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/assets/51', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Releases::Assets->list
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases::Assets', user => 'foo', repo => 'bar' );

    throws_ok { $obj->list } qr{Missing key in parameters: release_id}, 'No parameters';

    isa_ok $obj, 'Pithub::Repos::Releases::Assets';

    {
        my $result = $obj->list( release_id => 51 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/51/assets', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Releases::Assets->update
{
    my $json = JSON->new;
    my $obj = Pithub::Test->create( 'Pithub::Repos::Releases::Assets', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Releases::Assets';
    throws_ok { $obj->update } qr{Missing key in parameters: asset_id}, 'No parameters';
    throws_ok { $obj->update(asset_id => 1) } qr{Missing key in parameters: data}, 'No data parameter';
    throws_ok { $obj->update(asset_id => 1, data => {}) } qr{Access token required for: PATCH /repos/foo/bar/releases/assets/1}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->update(asset_id => 1, data => { name => 'foo', label => 'bar' });
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/releases/assets/1', 'HTTP path';
        eq_or_diff $json->decode( $result->request->content ),
          { name => 'foo', label => 'bar', },
          'HTTP body';
    }
}

# Pithub::Repos::Starring->has_watching
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Starring', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Starring';

    throws_ok { $obj->has_starred } qr{Access token required for: GET /user/starred/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->has_starred;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/starred/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Starring->list_repos
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Starring', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Starring';

    {
        my $result = $obj->list_repos( user => 'bla' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/bla/starred', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->list_repos;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/starred', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Starring->star
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Starring', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Starring';

    throws_ok { $obj->star } qr{Access token required for: PUT /user/starred/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->star;
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/user/starred/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Starring->unstar
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Starring', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Starring';

    throws_ok { $obj->unstar } qr{Access token required for: DELETE /user/starred/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->unstar;
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/user/starred/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Watching->is_watching
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Watching', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Watching';

    throws_ok { $obj->is_watching } qr{Access token required for: GET /user/watched/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->is_watching;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/watched/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Watching->list_repos
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Watching', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Watching';

    throws_ok { $obj->list_repos } qr{Access token required for: GET /user/watched}, 'Token required';

    {
        my $result = $obj->list_repos( user => 'bla' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/users/bla/watched', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }

    {
        ok $obj->token(123), 'Token set';
        my $result = $obj->list_repos;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/user/watched', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Watching->start_watching
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Watching', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Watching';

    throws_ok { $obj->start_watching } qr{Access token required for: PUT /user/watched/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->start_watching;
        is $result->request->method, 'PUT', 'HTTP method';
        is $result->request->uri->path, '/user/watched/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Watching->stop_watching
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Watching', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Watching';

    throws_ok { $obj->stop_watching } qr{Access token required for: DELETE /user/watched/foo/bar}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->stop_watching;
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/user/watched/foo/bar', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Hooks->list
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Hooks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Hooks';

    throws_ok { $obj->list } qr{Access token required for: GET /repos/foo/bar/hooks}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->list( user => 'plu' );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/plu/bar/hooks', 'HTTP path';
    }
}

# Pithub::Repos::Hooks->get
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Hooks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Hooks';

    throws_ok { $obj->get } qr{Missing key in parameters: hook_id}, 'No parameters';
    throws_ok { $obj->get( hook_id => 5 ) } qr{Access token required for: GET /repos/foo/bar/hooks/5}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->get( hook_id => 123 );
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/hooks/123', 'HTTP path';
    }
}

# Pithub::Repos::Hooks->delete
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Hooks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Hooks';

    throws_ok { $obj->delete } qr{Missing key in parameters: hook_id}, 'No parameters';
    throws_ok { $obj->delete( hook_id => 5 ) } qr{Access token required for: DELETE /repos/foo/bar/hooks/5}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->delete( hook_id => 123 );
        is $result->request->method, 'DELETE', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/hooks/123', 'HTTP path';
    }
}

# Pithub::Repos::Hooks->test
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Hooks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Hooks';

    throws_ok { $obj->test } qr{Missing key in parameters: hook_id}, 'No parameters';
    throws_ok { $obj->test( hook_id => 5 ) } qr{Access token required for: POST /repos/foo/bar/hooks/5/test}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $result = $obj->test( hook_id => 123 );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/hooks/123/test', 'HTTP path';
    }
}

# Pithub::Repos::Hooks->create
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Hooks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Hooks';

    throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok {
        $obj->create( data => { name => 'web' } );
    }
    qr{Access token required for: POST /repos/foo/bar/hooks}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->create( data => { name => 'web' } );
        is $result->request->method, 'POST', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/hooks', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'name' => 'web' }, 'HTTP body';
    }
}

# Pithub::Repos::Hooks->update
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Hooks', user => 'foo', repo => 'bar' );

    isa_ok $obj, 'Pithub::Repos::Hooks';

    throws_ok { $obj->update } qr{Missing key in parameters: hook_id}, 'No parameters';
    throws_ok { $obj->update( hook_id => 123 ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
    throws_ok { $obj->update( hook_id => 123, data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong type';
    throws_ok {
        $obj->update( hook_id => 123, data => { name => 'irc' } );
    }
    qr{Access token required for: PATCH /repos/foo/bar/hooks/123}, 'Token required';

    ok $obj->token(123), 'Token set';

    {
        my $json = JSON->new;
        my $result = $obj->update( hook_id => 123, data => { name => 'irc' } );
        is $result->request->method, 'PATCH', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/hooks/123', 'HTTP path';
        my $http_request = $result->request;
        eq_or_diff $json->decode( $http_request->content ), { 'name' => 'irc' }, 'HTTP body';
    }
}

# Pithub::Repos::Stats->contributors
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Stats', user => 'foo', repo => 'bar' );

    isa_ok $obj, "Pithub::Repos::Stats";

    {
        my $result = $obj->contributors;
        is $result->request->method, 'GET', 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/stats/contributors', 'HTTP path';
        my $http_request = $result->request;
        is $http_request->content, '', 'HTTP body';
    }
}

# Pithub::Repos::Statuses->list
#
# Pithub::Repos::Statuses->create
#
{
    my $obj = Pithub::Test->create( 'Pithub::Repos::Statuses', user => 'foo', repo => 'bar' );
    isa_ok $obj, "Pithub::Repos::Statuses";

    {
        my $result = $obj->list( ref => 'abcdef' );
        is $result->request->method, "GET", 'HTTP method';
        is $result->request->uri->path, '/repos/foo/bar/statuses/abcdef', "HTTP Path";
        is $result->request->content, '', 'HTTP body';
    }
    {
        my $json = JSON->new;
        my $result = $obj->create( sha => '0123456', data => {
                state => 'error', description => 'testing'
            },);
        is $result->request->method, "POST", "HTTP method";
        is $result->request->uri->path, '/repos/foo/bar/statuses/0123456', 'HTTP path';
        eq_or_diff $json->decode( $result->request->content ), { 'description' => 'testing', 'state' => 'error' }, 'HTTP body';
    }
}

done_testing;
