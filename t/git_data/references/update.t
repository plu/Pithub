use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::GitData::References');
}

my $obj = Pithub::Test->create( 'Pithub::GitData::References', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::GitData::References';

throws_ok { $obj->update } qr{Missing key in parameters: ref}, 'No parameters';
throws_ok { $obj->update( ref => 'foo/bar' ) } qr{Missing key in parameters: data \(hashref\)}, 'No data parameter';
throws_ok { $obj->update( ref => 'foo/bar', data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->update( ref => 'foo/bar', data => { sha => 123 } ); } qr{Access token required for: PATCH /repos/foo/bar/git/refs}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->update( ref => 'foo/bar', data => { sha => '123' } );
    is $result->request->method, 'PATCH', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/git/refs/foo/bar', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"sha":"123"}', 'HTTP body';
}

done_testing;
