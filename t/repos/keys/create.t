use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Keys');
}

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

done_testing;
