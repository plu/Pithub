use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Watching');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Watching', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Watching';

throws_ok { $obj->list_repos } qr{Access token required for: GET /user/watched}, 'Token required';

{
    my $result = $obj->list_repos( user => 'bla' );
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/users/bla/watched', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

{
    ok $obj->token(123), 'Token set';
    my $result = $obj->list_repos;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/watched', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
