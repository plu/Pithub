use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Gists');
}

my $obj = Pithub::Test->create('Pithub::Gists');

isa_ok $obj, 'Pithub::Gists';

{
    my $result = $obj->list( user => 'foo' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/users/foo/gists', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

{
    throws_ok { $obj->list( starred => 1 ) } qr{Access token required for: GET /gists/starred }, 'Token required';
    ok $obj->token(123), 'Token set';
    my $result = $obj->list( starred => 1 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/gists/starred', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
    ok $obj->clear_token, 'Token removed';
}

{
    my $result = $obj->list( public => 1 );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/gists/public', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

{
    my $result = $obj->list;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/gists', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
