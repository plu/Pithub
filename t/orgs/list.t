use FindBin;
use lib "$FindBin::Bin/../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Orgs');
}

my $obj = Pithub::Test->create( 'Pithub::Orgs', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Orgs';

{
    my $result = $obj->list( user => 'foo' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/users/foo/orgs', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

{
    throws_ok { $obj->list } qr{Access token required for: GET /user/orgs}, 'Token required';
    ok $obj->token(123), 'Token set';
    my $result = $obj->list;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/orgs', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
