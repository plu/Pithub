use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Issues::Labels');
}

my $obj = Pithub::Test->create( 'Pithub::Issues::Labels', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Issues::Labels';

throws_ok { $obj->remove } qr{Missing key in parameters: issue_id}, 'No parameters';
throws_ok { $obj->remove( issue_id => 123 ); } qr{Access token required for: DELETE /repos/foo/bar/issues/123/labels\s+}, 'Token required';
throws_ok { $obj->remove( issue_id => 123, label_id => 456 ); } qr{Access token required for: DELETE /repos/foo/bar/issues/123/labels/456\s+}, 'Token required';

ok $obj->token(123), 'Token set';

{
    my $result = $obj->remove( issue_id => 123 );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/123/labels', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

{
    my $result = $obj->remove( issue_id => 123, label_id => 456 );
    is $result->request->method, 'DELETE', 'HTTP method';
    is $result->request->uri->path, '/repos/foo/bar/issues/123/labels/456', 'HTTP path';
    my $http_request = $result->request->http_request;
    is $http_request->content, '', 'HTTP body';
}

done_testing;
