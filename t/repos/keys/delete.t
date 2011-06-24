use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Keys');
}

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

done_testing;
