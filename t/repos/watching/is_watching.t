use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Watching');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Watching', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Watching';

throws_ok { $obj->is_watching } qr{Access token required for: GET /user/watched/foo/bar}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->is_watching;
    is $result->request->method, 'GET', 'HTTP method';
    is $result->request->uri->path, '/user/watched/foo/bar', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
