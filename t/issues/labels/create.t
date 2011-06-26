use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Labels');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Labels';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->create( data => { name => 'foo' } ); } qr{Access token required for: POST /repos/foo/bar/labels\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create(
        data => {
            name  => 'label1',
            color => '#FFFFFF',
        }
    );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/labels', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"color":"#FFFFFF","name":"label1"}', 'HTTP body';
}

done_testing;
