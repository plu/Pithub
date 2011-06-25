use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::GitData::References');
}

my $obj = Pithub::Test->create( 'Pithub::GitData::References', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::GitData::References';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->create( data => { ref => 'refs/heads/master' } ); } qr{Access token required for: POST /repos/foo/bar/git/refs}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create( data => { ref => 'refs/heads/master' } );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/git/refs', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"ref":"refs/heads/master"}', 'HTTP body';
}

done_testing;
