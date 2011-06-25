use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::GitData::Trees');
}

my $obj = Pithub::Test->create( 'Pithub::GitData::Trees', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::GitData::Trees';

throws_ok { $obj->create } qr{Missing key in parameters: data \(hashref\)}, 'No parameters';
throws_ok { $obj->create( data => 5 ) } qr{Missing key in parameters: data \(hashref\)}, 'Wrong data parameter';
throws_ok { $obj->create( data => { tree => [ { path => 'file1.pl' } ] } ); } qr{Access token required for: POST /repos/foo/bar/git/trees}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->create( data => { tree => [ { path => 'file1.pl' } ] } );
    is $result->request->method, 'POST', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/git/trees', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '{"tree":[{"path":"file1.pl"}]}', 'HTTP body';
}

done_testing;
